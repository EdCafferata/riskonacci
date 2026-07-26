import Foundation

/// One document per participant per round
/// (`rooms/{roomID}/votes/{authUID}_{roundKey}`), owned by that
/// participant's own device. `epoch` ties a vote to a specific round of
/// the room (bumped by the host on every reset) — everyone only reads
/// votes matching the room's current epoch, so a stale vote from before a
/// reset is simply ignored rather than needing to be deleted by someone
/// who doesn't have permission to.
struct FirebaseVoteDocument: Codable {
    enum RoundKey: String, CaseIterable, Codable {
        case single, likelihood, impact

        init(_ round: RiskRound?) {
            switch round {
            case nil: self = .single
            case .likelihood: self = .likelihood
            case .impact: self = .impact
            }
        }

        var round: RiskRound? {
            switch self {
            case .single: nil
            case .likelihood: .likelihood
            case .impact: .impact
            }
        }
    }

    var participantID: String
    var roundKey: RoundKey
    var cardLabel: String
    var epoch: Int

    static let collection = "votes"

    static func documentID(participantID: String, roundKey: RoundKey) -> String {
        "\(participantID)_\(roundKey.rawValue)"
    }
}
