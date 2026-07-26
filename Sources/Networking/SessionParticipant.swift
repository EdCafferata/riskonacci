import Foundation

/// Deliberately just an id + a self-chosen nickname — no avatar/photo, so
/// nothing but a display name ever has to travel over the wire or through
/// Firebase. `id` is Firebase Auth's own anonymous-user UID string.
struct SessionParticipant: Codable, Identifiable, Hashable {
    let id: String
    var nickname: String
}
