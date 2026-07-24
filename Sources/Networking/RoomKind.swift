import Foundation

/// Which transport backs a room: `local` never leaves the Wi-Fi network
/// (`MultipeerSessionTransport`), `online` works from anywhere over
/// CloudKit's public database (`CloudKitSessionTransport`).
enum RoomKind {
    case local
    case online
}
