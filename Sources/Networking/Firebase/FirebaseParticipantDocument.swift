import Foundation

/// One document per participant (`rooms/{roomID}/participants/{authUID}`),
/// owned by that participant's own device — the document ID is literally
/// their Firebase Auth (anonymous) UID, which is what makes the Firestore
/// security rule for this collection a simple, exact match rather than a
/// query. `lastSeen` is a heartbeat: other devices treat a participant as
/// gone once it's stale for too long, without needing permission to
/// delete that participant's own record.
struct FirebaseParticipantDocument: Codable {
    var nickname: String
    var lastSeen: Date

    static let collection = "participants"

    init(nickname: String) {
        self.nickname = nickname
        self.lastSeen = Date()
    }
}
