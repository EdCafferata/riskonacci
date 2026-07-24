import CloudKit
import Foundation

/// The single record every device in an online room shares — one row per
/// room, `recordName` fixed to the room ID so any device can fetch it
/// directly without needing a query index. Deck/settings/reveal state
/// lives here; only the current host writes it. `hostID`/`hostHeartbeatAt`
/// let a room survive its host disappearing: if the heartbeat goes stale,
/// the participant with the lexicographically smallest ID among the still-
/// active roster claims the record for itself (see
/// `CloudKitSessionTransport`), the same election rule already used by the
/// local-network mesh transport.
struct CloudKitRoomRecord {
    static let recordType = "Room"

    let roomID: String
    var hostID: UUID
    var hostHeartbeatAt: Date
    var deckRaw: String
    var twoRoundsEnabled: Bool
    var isRevealed: Bool
    var epoch: Int64

    private enum Field {
        static let hostID = "hostID"
        static let hostHeartbeatAt = "hostHeartbeatAt"
        static let deckRaw = "deckRaw"
        static let twoRoundsEnabled = "twoRoundsEnabled"
        static let isRevealed = "isRevealed"
        static let epoch = "epoch"
    }

    static func recordID(roomID: String) -> CKRecord.ID {
        CKRecord.ID(recordName: "room_\(roomID)")
    }

    init(roomID: String, hostID: UUID, deckRaw: String, twoRoundsEnabled: Bool) {
        self.roomID = roomID
        self.hostID = hostID
        self.hostHeartbeatAt = Date()
        self.deckRaw = deckRaw
        self.twoRoundsEnabled = twoRoundsEnabled
        self.isRevealed = false
        self.epoch = 0
    }

    init?(record: CKRecord, roomID: String) {
        guard
            let hostIDString = record[Field.hostID] as? String,
            let hostID = UUID(uuidString: hostIDString),
            let heartbeat = record[Field.hostHeartbeatAt] as? Date,
            let deckRaw = record[Field.deckRaw] as? String,
            let twoRounds = record[Field.twoRoundsEnabled] as? Int64,
            let revealed = record[Field.isRevealed] as? Int64,
            let epoch = record[Field.epoch] as? Int64
        else { return nil }
        self.roomID = roomID
        self.hostID = hostID
        self.hostHeartbeatAt = heartbeat
        self.deckRaw = deckRaw
        self.twoRoundsEnabled = twoRounds != 0
        self.isRevealed = revealed != 0
        self.epoch = epoch
    }

    /// Applies this value onto a (possibly server-fetched) `CKRecord`, so
    /// callers can round-trip a record through `ifServerRecordUnchanged`
    /// saves without losing its `recordChangeTag`.
    func apply(to record: CKRecord) {
        record[Field.hostID] = hostID.uuidString
        record[Field.hostHeartbeatAt] = hostHeartbeatAt
        record[Field.deckRaw] = deckRaw
        record[Field.twoRoundsEnabled] = twoRoundsEnabled ? Int64(1) : Int64(0)
        record[Field.isRevealed] = isRevealed ? Int64(1) : Int64(0)
        record[Field.epoch] = epoch
    }

    func makeRecord() -> CKRecord {
        let record = CKRecord(recordType: Self.recordType, recordID: Self.recordID(roomID: roomID))
        apply(to: record)
        return record
    }
}
