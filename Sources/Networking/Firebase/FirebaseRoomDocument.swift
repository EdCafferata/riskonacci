import FirebaseFirestore
import Foundation

/// The single document every device in a room shares (`rooms/{roomID}`) —
/// deck/settings/reveal state, owned by whoever currently believes it's
/// host. Any current participant is allowed to write this document (see
/// the Firestore security rules in the repo README) so host migration
/// works the same way it did for the local-network mesh: whoever has the
/// lexicographically smallest participant ID just starts writing again.
struct FirebaseRoomDocument: Codable {
    var hostID: String
    var hostHeartbeatAt: Date
    var deckRaw: String
    var twoRoundsEnabled: Bool
    var isRevealed: Bool
    var epoch: Int

    static let collection = "rooms"

    init(hostID: String, deckRaw: String, twoRoundsEnabled: Bool) {
        self.hostID = hostID
        self.hostHeartbeatAt = Date()
        self.deckRaw = deckRaw
        self.twoRoundsEnabled = twoRoundsEnabled
        self.isRevealed = false
        self.epoch = 0
    }
}
