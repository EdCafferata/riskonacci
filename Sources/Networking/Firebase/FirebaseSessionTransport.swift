import FirebaseAuth
import FirebaseFirestore
import Foundation

/// Multiplayer transport backed by Firebase — replaces both the old
/// local-network mesh (MultipeerConnectivity) and CloudKit-signaled
/// online rooms with one shared backend that works identically for
/// local and remote play, and interoperates with the Android app (which
/// speaks the exact same Firestore schema). "Nearby" vs "Online" is now
/// purely a UI label, not a different transport.
///
/// Real-time Firestore listeners replace CloudKit's polling loop — state
/// changes push to every device immediately instead of waiting for the
/// next poll tick. A lightweight heartbeat still runs periodically, but
/// only to broadcast "I'm still here" (`lastSeen`/`hostHeartbeatAt`), not
/// to fetch anything.
///
/// Host election reuses the same rule as before — lexicographically
/// smallest participant ID among the currently-active roster — computed
/// independently here so this transport can decide for itself when to
/// (re)claim write ownership of the room document after the original
/// host disappears. Firestore's security rules (see the repo README) let
/// *any* current participant write the room document, so — unlike
/// CloudKit's creator-only default — host migration works out of the box.
@MainActor
final class FirebaseSessionTransport: SessionTransport {
    private static let heartbeatInterval: Duration = .seconds(5)
    private static let staleThreshold: TimeInterval = 15

    private(set) var localParticipantID: String = ""
    private var localNickname = ""
    private var roomID = ""

    private let db = Firestore.firestore()
    private var roomListener: ListenerRegistration?
    private var participantsListener: ListenerRegistration?
    private var votesListener: ListenerRegistration?
    private var heartbeatTask: Task<Void, Never>?

    private var hasReceivedInitialRoster = false
    private var activeParticipants: [String: Date] = [:]
    private var knownDeckRaw: String?
    private var knownTwoRoundsEnabled: Bool?
    private var knownEpoch: Int?
    private var knownIsRevealed: Bool?
    private var lastSeenVote: [String: String] = [:]

    var onReceive: ((SessionMessage, String) -> Void)?
    var onPeerConnected: ((String, String) -> Void)?
    var onPeerDisconnected: ((String) -> Void)?

    /// Gated on `hasReceivedInitialRoster` so a just-joined device doesn't
    /// briefly see only itself and wrongly conclude it's the sole (and
    /// therefore host) participant before the first roster snapshot
    /// arrives.
    private var computedLocalIsHost: Bool {
        hasReceivedInitialRoster && activeParticipants.keys.min() == localParticipantID
    }

    private var roomRef: DocumentReference { db.collection(FirebaseRoomDocument.collection).document(roomID) }

    func startHosting(roomID: String, nickname: String) {
        self.roomID = roomID
        localNickname = nickname
        Task {
            await ensureSignedIn()
            activeParticipants[localParticipantID] = Date()
            try? roomRef.setData(from: FirebaseRoomDocument(hostID: localParticipantID, deckRaw: Deck.risk.rawValue, twoRoundsEnabled: true))
            await upsertOwnParticipantDocument()
            startListening()
            startHeartbeat()
        }
    }

    func join(roomID: String, nickname: String) {
        self.roomID = roomID
        localNickname = nickname
        Task {
            await ensureSignedIn()
            activeParticipants[localParticipantID] = Date()
            await upsertOwnParticipantDocument()
            startListening()
            startHeartbeat()
        }
    }

    func send(_ message: SessionMessage) {
        Task { await handleSend(message) }
    }

    func stop() {
        roomListener?.remove()
        participantsListener?.remove()
        votesListener?.remove()
        heartbeatTask?.cancel()
        roomListener = nil
        participantsListener = nil
        votesListener = nil
        heartbeatTask = nil

        let capturedRoomRef = roomRef
        let participantID = localParticipantID
        Task {
            try? await capturedRoomRef.collection(FirebaseParticipantDocument.collection).document(participantID).delete()
            for key in FirebaseVoteDocument.RoundKey.allCases {
                try? await capturedRoomRef.collection(FirebaseVoteDocument.collection)
                    .document(FirebaseVoteDocument.documentID(participantID: participantID, roundKey: key))
                    .delete()
            }
        }
        activeParticipants = [:]
        hasReceivedInitialRoster = false
    }

    // MARK: Auth

    private func ensureSignedIn() async {
        if let user = Auth.auth().currentUser {
            localParticipantID = user.uid
            return
        }
        guard let result = try? await Auth.auth().signInAnonymously() else {
            return // no network at all — transport degrades to a harmless no-op
        }
        localParticipantID = result.user.uid
    }

    // MARK: Sending

    private func handleSend(_ message: SessionMessage) async {
        switch message {
        case .hello, .roster:
            break // identity/roster travel via Participant documents, not messages

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
            let roundKey = FirebaseVoteDocument.RoundKey(round)
            let doc = FirebaseVoteDocument(participantID: participantID, roundKey: roundKey, cardLabel: cardLabel, epoch: epoch)
            try? voteRef(participantID: participantID, roundKey: roundKey).setData(from: doc)

        case .clearVote(let participantID):
            guard participantID == localParticipantID else { return }
            for key in FirebaseVoteDocument.RoundKey.allCases {
                try? await voteRef(participantID: participantID, roundKey: key).delete()
            }

        case .clearRoundVote(let participantID, let round):
            guard participantID == localParticipantID else { return }
            try? await voteRef(participantID: participantID, roundKey: .init(round)).delete()
        }
    }

    /// Fetches the current room document, applies `change`, and writes it
    /// back. Only meant to be called by whoever currently believes it's
    /// host; a permission failure (not a current participant) or a
    /// transient network error is silently dropped rather than fatal.
    private func mutateRoom(_ change: (inout FirebaseRoomDocument) -> Void) async {
        guard computedLocalIsHost else { return }
        guard let snapshot = try? await roomRef.getDocument(),
              var room = try? snapshot.data(as: FirebaseRoomDocument.self)
        else { return }
        change(&room)
        room.hostID = localParticipantID
        room.hostHeartbeatAt = Date()
        try? roomRef.setData(from: room)
    }

    private func voteRef(participantID: String, roundKey: FirebaseVoteDocument.RoundKey) -> DocumentReference {
        roomRef.collection(FirebaseVoteDocument.collection)
            .document(FirebaseVoteDocument.documentID(participantID: participantID, roundKey: roundKey))
    }

    // MARK: Real-time listeners

    private func startListening() {
        roomListener = roomRef.addSnapshotListener { [weak self] snapshot, _ in
            guard let self, let snapshot, let room = try? snapshot.data(as: FirebaseRoomDocument.self) else { return }
            Task { @MainActor in self.handleRoomUpdate(room) }
        }

        participantsListener = roomRef.collection(FirebaseParticipantDocument.collection)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self, let snapshot else { return }
                var seen: [String: (Date, String)] = [:]
                for doc in snapshot.documents {
                    guard let participant = try? doc.data(as: FirebaseParticipantDocument.self) else { continue }
                    seen[doc.documentID] = (participant.lastSeen, participant.nickname)
                }
                Task { @MainActor in self.handleParticipantsUpdate(seen) }
            }

        votesListener = roomRef.collection(FirebaseVoteDocument.collection)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self, let snapshot else { return }
                let votes = snapshot.documents.compactMap { try? $0.data(as: FirebaseVoteDocument.self) }
                Task { @MainActor in self.handleVotesUpdate(votes) }
            }
    }

    private func handleRoomUpdate(_ room: FirebaseRoomDocument) {
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

    private func handleParticipantsUpdate(_ seen: [String: (Date, String)]) {
        hasReceivedInitialRoster = true
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

    private func handleVotesUpdate(_ votes: [FirebaseVoteDocument]) {
        guard let epoch = knownEpoch else { return }
        for vote in votes {
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

    // MARK: Heartbeat

    private func startHeartbeat() {
        heartbeatTask?.cancel()
        heartbeatTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.sendHeartbeat()
                try? await Task.sleep(for: Self.heartbeatInterval)
            }
        }
    }

    private func sendHeartbeat() async {
        await upsertOwnParticipantDocument()
        if computedLocalIsHost {
            await mutateRoom { _ in } // apply() always stamps hostID/hostHeartbeatAt
        }
    }

    private func upsertOwnParticipantDocument() async {
        let doc = FirebaseParticipantDocument(nickname: localNickname)
        try? roomRef.collection(FirebaseParticipantDocument.collection).document(localParticipantID).setData(from: doc)
    }
}
