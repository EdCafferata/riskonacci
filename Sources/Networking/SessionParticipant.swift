import Foundation

/// Deliberately just an id + a self-chosen nickname — no avatar/photo, so
/// nothing but a display name ever has to travel over the wire or through
/// CloudKit signaling later.
struct SessionParticipant: Codable, Identifiable, Hashable {
    let id: UUID
    var nickname: String
}
