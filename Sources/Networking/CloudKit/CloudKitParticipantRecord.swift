import CloudKit
import Foundation

/// One record per participant per room, owned by that participant's own
/// device (only they ever write or delete it). `roomID` needs a queryable
/// index in the CloudKit Dashboard so every device can list "who's in this
/// room" — see the README's CloudKit setup section. `lastSeen` is a
/// heartbeat: other devices treat a participant as gone once it's stale for
/// too long, without needing permission to delete that participant's own
/// record.
struct CloudKitParticipantRecord {
    static let recordType = "Participant"
    static let roomIDField = "roomID"

    let roomID: String
    let participantID: UUID
    var nickname: String
    var lastSeen: Date

    private enum Field {
        static let participantID = "participantID"
        static let nickname = "nickname"
        static let lastSeen = "lastSeen"
    }

    static func recordID(roomID: String, participantID: UUID) -> CKRecord.ID {
        CKRecord.ID(recordName: "participant_\(roomID)_\(participantID.uuidString)")
    }

    init(roomID: String, participantID: UUID, nickname: String) {
        self.roomID = roomID
        self.participantID = participantID
        self.nickname = nickname
        self.lastSeen = Date()
    }

    init?(record: CKRecord) {
        guard
            let roomID = record[Self.roomIDField] as? String,
            let participantIDString = record[Field.participantID] as? String,
            let participantID = UUID(uuidString: participantIDString),
            let nickname = record[Field.nickname] as? String,
            let lastSeen = record[Field.lastSeen] as? Date
        else { return nil }
        self.roomID = roomID
        self.participantID = participantID
        self.nickname = nickname
        self.lastSeen = lastSeen
    }

    func makeRecord() -> CKRecord {
        let record = CKRecord(recordType: Self.recordType, recordID: Self.recordID(roomID: roomID, participantID: participantID))
        record[Self.roomIDField] = roomID
        record[Field.participantID] = participantID.uuidString
        record[Field.nickname] = nickname
        record[Field.lastSeen] = lastSeen
        return record
    }
}
