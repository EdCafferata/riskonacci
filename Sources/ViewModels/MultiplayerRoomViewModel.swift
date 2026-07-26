import Foundation
import Observation

/// Likelihood and Impact are tracked separately — a participant's Impact
/// pick must not overwrite their Likelihood pick, since the combined
/// reveal needs both at once.
struct VoteState {
    var likelihoodLabel: String?
    var impactLabel: String?
    var singleLabel: String?

    var hasVoted: Bool {
        singleLabel != nil || likelihoodLabel != nil || impactLabel != nil
    }
}

/// Room state for a live multiplayer session, backed by Firebase
/// (`FirebaseSessionTransport`) — every device reads/writes the same
/// Firestore room, so "host" isn't a role assigned at connect time, it's
/// whoever currently has the lexicographically smallest participant ID
/// among everyone still present, recomputed independently by each device
/// from its own view of the participant list. If the host disappears,
/// everyone else already agrees on who's next without any handoff
/// message.
@MainActor
@Observable
final class MultiplayerRoomViewModel {
    private(set) var roomID: String = ""
    private(set) var participants: [SessionParticipant] = []
    private(set) var selectedDeck: Deck = .risk
    var twoRoundsEnabled = true
    private(set) var votes: [String: VoteState] = [:]
    private(set) var isRevealed = false
    private(set) var connectionState: ConnectionState = .idle

    enum ConnectionState: Equatable {
        case idle, connecting, connected
    }

    private var transport: SessionTransport?
    private var localNickname = ""

    var localParticipantID: String? { transport?.localParticipantID }

    /// Lexicographically smallest participant ID currently connected —
    /// the same rule evaluated independently on every device, so they
    /// always agree without needing to coordinate.
    var hostID: String? {
        participants.map(\.id).min()
    }

    var isHost: Bool {
        hostID != nil && hostID == localParticipantID
    }

    var isTwoRoundFlow: Bool {
        selectedDeck == .risk && twoRoundsEnabled
    }

    func hostRoom(nickname: String) {
        localNickname = nickname
        roomID = RoomID.generate()
        connectionState = .connecting

        let transport = FirebaseSessionTransport()
        wire(transport)
        self.transport = transport
        transport.startHosting(roomID: roomID, nickname: nickname)

        participants = [SessionParticipant(id: transport.localParticipantID, nickname: nickname)]
        connectionState = .connected
    }

    func joinRoom(roomID: String, nickname: String) {
        localNickname = nickname
        self.roomID = roomID
        connectionState = .connecting

        let transport = FirebaseSessionTransport()
        wire(transport)
        self.transport = transport
        transport.join(roomID: roomID, nickname: nickname)

        participants = [SessionParticipant(id: transport.localParticipantID, nickname: nickname)]
    }

    func leave() {
        transport?.stop()
        transport = nil
        participants = []
        votes = [:]
        isRevealed = false
        connectionState = .idle
    }

    // MARK: Host-only actions
    // "Host-only" is enforced by the `isHost` guard below, not by only the
    // host being able to reach the network — anyone could technically
    // send these, they just won't take effect locally unless the
    // election agrees they're host, and Firestore's security rules only
    // let a current participant write the shared room document at all.

    func selectDeck(_ deck: Deck) {
        guard isHost else { return }
        selectedDeck = deck
        resetRound()
        transport?.send(.deckChanged(deck))
    }

    func setTwoRoundsEnabled(_ enabled: Bool) {
        guard isHost else { return }
        twoRoundsEnabled = enabled
        resetRound()
        transport?.send(.settingsChanged(twoRoundsEnabled: enabled))
    }

    func resetRound() {
        guard isHost else { return }
        votes = [:]
        isRevealed = false
        transport?.send(.reset)
    }

    func reveal() {
        guard isHost else { return }
        isRevealed = true
        transport?.send(.reveal)
    }

    // MARK: Voting (any participant)

    /// The round the participant hasn't voted on yet, or nil once both are done.
    func currentRound(for participantID: String) -> RiskRound? {
        guard isTwoRoundFlow else { return nil }
        let vote = votes[participantID]
        if vote?.likelihoodLabel == nil { return .likelihood }
        if vote?.impactLabel == nil { return .impact }
        return nil
    }

    func pick(_ card: PokerCard) {
        guard let localID = localParticipantID else { return }
        var state = votes[localID] ?? VoteState()
        let round: RiskRound?

        if isTwoRoundFlow {
            round = state.likelihoodLabel == nil ? .likelihood : .impact
            if round == .likelihood {
                state.likelihoodLabel = card.label
            } else {
                state.impactLabel = card.label
            }
        } else {
            round = nil
            state.singleLabel = card.label
        }

        votes[localID] = state
        transport?.send(.vote(participantID: localID, round: round, cardLabel: card.label))
    }

    func hasVoted(_ participantID: String) -> Bool {
        votes[participantID]?.hasVoted ?? false
    }

    /// True once the local player has voted at least once in the current
    /// two-round flow, i.e. there's something to step back to.
    var canGoBack: Bool {
        guard isTwoRoundFlow, let localID = localParticipantID else { return false }
        return votes[localID]?.likelihoodLabel != nil
    }

    /// Steps back one round (Impact → Likelihood) so the answer can be
    /// changed, without discarding the other round's already-cast vote.
    func goBack() {
        guard let localID = localParticipantID, var state = votes[localID] else { return }
        let round: RiskRound
        if state.impactLabel != nil {
            state.impactLabel = nil
            round = .impact
        } else if state.likelihoodLabel != nil {
            state.likelihoodLabel = nil
            round = .likelihood
        } else {
            return
        }
        votes[localID] = state
        transport?.send(.clearRoundVote(participantID: localID, round: round))
    }

    // MARK: Wiring

    private func wire(_ transport: SessionTransport) {
        transport.onPeerConnected = { [weak self] id, nickname in
            self?.handlePeerConnected(id: id, nickname: nickname)
        }
        transport.onPeerDisconnected = { [weak self] id in
            self?.handlePeerDisconnected(id: id)
        }
        transport.onReceive = { [weak self] message, senderID in
            self?.handle(message, from: senderID)
        }
    }

    private func handlePeerConnected(id: String, nickname: String) {
        connectionState = .connected
        if !participants.contains(where: { $0.id == id }) {
            participants.append(SessionParticipant(id: id, nickname: nickname))
        }
        // Bring a newly-connected peer up to date on room state. Harmless
        // if several existing members all do this — everyone converges on
        // the same values — but only the (now newly re-evaluated) host
        // bothers, to avoid a burst of redundant messages.
        if isHost {
            transport?.send(.deckChanged(selectedDeck))
            transport?.send(.settingsChanged(twoRoundsEnabled: twoRoundsEnabled))
        }
    }

    private func handlePeerDisconnected(id: String) {
        participants.removeAll { $0.id == id }
        votes[id] = nil
    }

    private func handle(_ message: SessionMessage, from senderID: String) {
        switch message {
        case .hello:
            break // handled by the transport itself to resolve identity

        case .roster:
            break // no longer used — everyone builds their own roster directly

        case .deckChanged(let deck):
            selectedDeck = deck

        case .settingsChanged(let twoRoundsEnabled):
            self.twoRoundsEnabled = twoRoundsEnabled

        case .vote(let participantID, let round, let cardLabel):
            var state = votes[participantID] ?? VoteState()
            switch round {
            case .likelihood: state.likelihoodLabel = cardLabel
            case .impact: state.impactLabel = cardLabel
            case nil: state.singleLabel = cardLabel
            }
            votes[participantID] = state

        case .clearVote(let participantID):
            votes[participantID] = nil

        case .clearRoundVote(let participantID, let round):
            var state = votes[participantID] ?? VoteState()
            switch round {
            case .likelihood: state.likelihoodLabel = nil
            case .impact: state.impactLabel = nil
            }
            votes[participantID] = state

        case .reset:
            votes = [:]
            isRevealed = false

        case .reveal:
            isRevealed = true
        }
    }
}
