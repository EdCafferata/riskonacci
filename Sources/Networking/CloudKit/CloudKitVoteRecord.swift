import CloudKit
import Foundation

/// One record per participant per round, owned by that participant's own
/// device. `epoch` ties a vote to a specific round of the room (bumped by
/// the host on every reset) — everyone queries only votes matching the
/// room's current epoch, so a stale vote from before a reset is simply
/// ignored by other devices rather than needing to be deleted by someone
/// who doesn't have permission to.
struct CloudKitVoteRecord {
    static let recordType = "Vote"
    static let roomIDField = "roomID"

    enum RoundKey: String, CaseIterable {
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
            case .single: return nil
            case .likelihood: return .likelihood
            case .impact: return .impact
            }
        }
    }

    let roomID: String
    let participantID: UUID
    let roundKey: RoundKey
    var cardLabel: String
    var epoch: Int64

    private enum Field {
        static let participantID = "participantID"
        static let round = "round"
        static let cardLabel = "cardLabel"
        static let epoch = "epoch"
    }

    static func recordID(roomID: String, participantID: UUID, roundKey: RoundKey) -> CKRecord.ID {
        CKRecord.ID(recordName: "vote_\(roomID)_\(participantID.uuidString)_\(roundKey.rawValue)")
    }

    init(roomID: String, participantID: UUID, roundKey: RoundKey, cardLabel: String, epoch: Int64) {
        self.roomID = roomID
        self.participantID = participantID
        self.roundKey = roundKey
        self.cardLabel = cardLabel
        self.epoch = epoch
    }

    init?(record: CKRecord) {
        guard
            let roomID = record[Self.roomIDField] as? String,
            let participantIDString = record[Field.participantID] as? String,
            let participantID = UUID(uuidString: participantIDString),
            let roundRaw = record[Field.round] as? String,
            let roundKey = RoundKey(rawValue: roundRaw),
            let cardLabel = record[Field.cardLabel] as? String,
            let epoch = record[Field.epoch] as? Int64
        else { return nil }
        self.roomID = roomID
        self.participantID = participantID
        self.roundKey = roundKey
        self.cardLabel = cardLabel
        self.epoch = epoch
    }

    func makeRecord() -> CKRecord {
        let record = CKRecord(recordType: Self.recordType, recordID: Self.recordID(roomID: roomID, participantID: participantID, roundKey: roundKey))
        record[Self.roomIDField] = roomID
        record[Field.participantID] = participantID.uuidString
        record[Field.round] = roundKey.rawValue
        record[Field.cardLabel] = cardLabel
        record[Field.epoch] = epoch
        return record
    }
}
