import CloudKit
import Foundation

/// Online multiplayer, no server of Ed's own: every device polls the same
/// three CloudKit public-database record types (`Room`, `Participant`,
/// `Vote` — see their own files) for a shared room ID. Privacy design (per
/// project notes): nothing about a session is meant to persist — Participant
/// and Vote records are owned by the device that created them and get
/// deleted again on a clean `stop()`; only `Room` (deck/settings/reveal
/// state) briefly outlives a session until its creator's next launch
/// deletes it. CloudKit here is purely a matchmaking/relay mechanism, not
/// long-term storage.
///
/// Host election reuses the exact same rule `MultiplayerRoomViewModel`
/// already uses for the local-network mesh transport — lexicographically
/// smallest participant ID among the currently-active roster — computed
/// independently here so this transport can decide for itself when to
/// (re)claim write ownership of the `Room` record after the original host
/// disappears. That reclaim only succeeds once the CloudKit Dashboard's
/// `Room` record type is granted "Authenticated: Read, Write" (default
/// CloudKit permissions only let a record's original creator modify it) —
/// see the README's CloudKit setup section. Until that's configured, a
/// dropped original host simply freezes shared room state for everyone
/// else, degrading gracefully rather than crashing.
@MainActor
final class CloudKitSessionTransport: SessionTransport {
    static let containerIdentifier = "iCloud.info.cafferata.riskonacci"

    private static let pollInterval: Duration = .seconds(2)
    private static let staleThreshold: TimeInterval = 12

    let localParticipantID = UUID()
    private var localNickname = ""
    private var roomID = ""

    private let container = CKContainer(identifier: containerIdentifier)
    private var database: CKDatabase { container.publicCloudDatabase }

    private var pollTask: Task<Void, Never>?

    private var activeParticipants: [UUID: Date] = [:]
    private var knownDeckRaw: String?
    private var knownTwoRoundsEnabled: Bool?
    private var knownEpoch: Int64?
    private var knownIsRevealed: Bool?
    private var lastSeenVote: [String: String] = [:]

    var onReceive: ((SessionMessage, UUID) -> Void)?
    var onPeerConnected: ((UUID, String) -> Void)?
    var onPeerDisconnected: ((UUID) -> Void)?

    private var computedLocalIsHost: Bool {
        activeParticipants.keys.min { $0.uuidString < $1.uuidString } == localParticipantID
    }

    func startHosting(roomID: String, nickname: String) {
        self.roomID = roomID
        localNickname = nickname
        activeParticipants[localParticipantID] = Date()
        Task {
            try? await database.save(CloudKitRoomRecord(roomID: roomID, hostID: localParticipantID, deckRaw: Deck.risk.rawValue, twoRoundsEnabled: true).makeRecord())
            await upsertOwnParticipantRecord()
            startPolling()
        }
    }

    func join(roomID: String, nickname: String) {
        self.roomID = roomID
        localNickname = nickname
        activeParticipants[localParticipantID] = Date()
        Task {
            await upsertOwnParticipantRecord()
            startPolling()
        }
    }

    func send(_ message: SessionMessage) {
        Task { await handleSend(message) }
    }

    func stop() {
        pollTask?.cancel()
        pollTask = nil
        let roomID = roomID
        let participantID = localParticipantID
        Task {
            try? await database.deleteRecord(withID: CloudKitParticipantRecord.recordID(roomID: roomID, participantID: participantID))
            for key in CloudKitVoteRecord.RoundKey.allCases {
                try? await database.deleteRecord(withID: CloudKitVoteRecord.recordID(roomID: roomID, participantID: participantID, roundKey: key))
            }
        }
        activeParticipants = [:]
    }

    // MARK: Sending

    private func handleSend(_ message: SessionMessage) async {
        switch message {
        case .hello, .roster:
            break // identity/roster travel via Participant records, not messages

        case .deckChanged(let deck):
            await mutateRoom { $0.deckRaw = deck.rawValue }

        case .settingsChanged(let twoRoundsEnabled):
            await mutateRoom { $0.twoRoundsEnabled = twoRoundsEnabled }

        case .reset:
            await mutateRoom {
                $0.epoch += 1
                $0.isRevealed = false
            }

        case .reveal:
            await mutateRoom { $0.isRevealed = true }

        case .vote(let participantID, let round, let cardLabel):
            guard participantID == localParticipantID, let epoch = knownEpoch else { return }
            let record = CloudKitVoteRecord(
                roomID: roomID, participantID: participantID,
                roundKey: .init(round), cardLabel: cardLabel, epoch: epoch
            )
            try? await database.save(record.makeRecord())

        case .clearVote(let participantID):
            guard participantID == localParticipantID else { return }
            for key in CloudKitVoteRecord.RoundKey.allCases {
                try? await database.deleteRecord(withID: CloudKitVoteRecord.recordID(roomID: roomID, participantID: participantID, roundKey: key))
            }

        case .clearRoundVote(let participantID, let round):
            guard participantID == localParticipantID else { return }
            try? await database.deleteRecord(withID: CloudKitVoteRecord.recordID(roomID: roomID, participantID: participantID, roundKey: .init(round)))
        }
    }

    /// Fetches the current `Room` record (to preserve its change tag for
    /// optimistic concurrency), applies `change`, and saves it back. Only
    /// meant to be called by whoever currently believes it's host; a save
    /// conflict or permission failure is silently dropped and picked up
    /// again on the next poll tick rather than treated as fatal.
    private func mutateRoom(_ change: (inout CloudKitRoomRecord) -> Void) async {
        guard computedLocalIsHost else { return }
        guard let record = try? await database.record(for: CloudKitRoomRecord.recordID(roomID: roomID)) else { return }
        guard var value = CloudKitRoomRecord(record: record, roomID: roomID) else { return }
        change(&value)
        value.hostID = localParticipantID
        value.hostHeartbeatAt = Date()
        value.apply(to: record)
        try? await database.save(record)
    }

    // MARK: Polling

    private func startPolling() {
        pollTask?.cancel()
        pollTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.pollOnce()
                try? await Task.sleep(for: Self.pollInterval)
            }
        }
    }

    private func pollOnce() async {
        await upsertOwnParticipantRecord()
        // Roster must be refreshed before host election runs — otherwise a
        // just-joined device would briefly see only itself in
        // `activeParticipants` and wrongly conclude it's the sole (and
        // therefore host) participant.
        await pollParticipants()
        await refreshHostHeartbeatIfNeeded()
        await pollRoom()
        await pollVotes()
    }

    private func refreshHostHeartbeatIfNeeded() async {
        guard computedLocalIsHost else { return }
        await mutateRoom { _ in } // apply() always stamps hostID/hostHeartbeatAt
    }

    private func pollRoom() async {
        guard let record = try? await database.record(for: CloudKitRoomRecord.recordID(roomID: roomID)),
              let room = CloudKitRoomRecord(record: record, roomID: roomID)
        else { return }

        if knownDeckRaw != room.deckRaw {
            knownDeckRaw = room.deckRaw
            if let deck = Deck(rawValue: room.deckRaw) {
                onReceive?(.deckChanged(deck), room.hostID)
            }
        }
        if knownTwoRoundsEnabled != room.twoRoundsEnabled {
            knownTwoRoundsEnabled = room.twoRoundsEnabled
            onReceive?(.settingsChanged(twoRoundsEnabled: room.twoRoundsEnabled), room.hostID)
        }
        if let previousEpoch = knownEpoch, previousEpoch != room.epoch {
            onReceive?(.reset, room.hostID)
        }
        knownEpoch = room.epoch
        if knownIsRevealed != room.isRevealed {
            knownIsRevealed = room.isRevealed
            if room.isRevealed {
                onReceive?(.reveal, room.hostID)
            }
        }
    }

    private func pollParticipants() async {
        let predicate = NSPredicate(format: "%K == %@", CloudKitParticipantRecord.roomIDField, roomID)
        let query = CKQuery(recordType: CloudKitParticipantRecord.recordType, predicate: predicate)
        guard let results = try? await database.records(matching: query) else { return }

        var seen: [UUID: (Date, String)] = [:]
        for (_, result) in results.matchResults {
            guard let record = try? result.get(), let participant = CloudKitParticipantRecord(record: record) else { continue }
            seen[participant.participantID] = (participant.lastSeen, participant.nickname)
        }

        let now = Date()
        let fresh = seen.filter { now.timeIntervalSince($0.value.0) < Self.staleThreshold }

        for (id, value) in fresh where activeParticipants[id] == nil {
            activeParticipants[id] = value.0
            if id != localParticipantID {
                onPeerConnected?(id, value.1)
            }
        }
        for id in activeParticipants.keys where fresh[id] == nil {
            activeParticipants[id] = nil
            if id != localParticipantID {
                onPeerDisconnected?(id)
            }
        }
        for (id, value) in fresh {
            activeParticipants[id] = value.0
        }
    }

    private func pollVotes() async {
        guard let epoch = knownEpoch else { return }
        let predicate = NSPredicate(format: "%K == %@", CloudKitVoteRecord.roomIDField, roomID)
        let query = CKQuery(recordType: CloudKitVoteRecord.recordType, predicate: predicate)
        guard let results = try? await database.records(matching: query) else { return }

        for (_, result) in results.matchResults {
            guard let record = try? result.get(), let vote = CloudKitVoteRecord(record: record) else { continue }
            guard vote.epoch == epoch, vote.participantID != localParticipantID else { continue }

            // Epoch is part of the key so a vote for the same card cast
            // again after a reset isn't mistaken for a stale duplicate of
            // the previous round's vote and dropped.
            let key = "\(vote.participantID)_\(vote.roundKey.rawValue)_\(vote.epoch)"
            guard lastSeenVote[key] != vote.cardLabel else { continue }
            lastSeenVote[key] = vote.cardLabel
            onReceive?(.vote(participantID: vote.participantID, round: vote.roundKey.round, cardLabel: vote.cardLabel), vote.participantID)
        }
    }

    private func upsertOwnParticipantRecord() async {
        let record = CloudKitParticipantRecord(roomID: roomID, participantID: localParticipantID, nickname: localNickname)
        try? await database.save(record.makeRecord())
    }
}
