import Foundation

/// Everything that travels between devices in a room. Cards are sent as
/// their `label` (a plain `String`) rather than the full `PokerCard` —
/// `PokerCard.tint` is a `Color`, which isn't `Codable`, and the label is
/// enough to look the card back up from the shared deck definition on the
/// receiving end.
enum SessionMessage: Codable {
    case hello(SessionParticipant)
    case roster([SessionParticipant])
    case deckChanged(Deck)
    case settingsChanged(twoRoundsEnabled: Bool)
    case vote(participantID: UUID, round: RiskRound?, cardLabel: String)
    case clearVote(participantID: UUID)
    /// Stepping back one round (e.g. Impact → Likelihood) to change an
    /// answer, without discarding the other round's vote too.
    case clearRoundVote(participantID: UUID, round: RiskRound)
    case reset
    case reveal
}
