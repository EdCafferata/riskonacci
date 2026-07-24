import Foundation

/// Abstraction over "how devices in a room talk to each other" — local
/// network today (`MultipeerSessionTransport`), CloudKit-signaled online
/// rooms later, both speaking the same `SessionMessage` protocol so the
/// room view model doesn't need to know which one is active.
@MainActor
protocol SessionTransport: AnyObject {
    var onReceive: ((SessionMessage, UUID) -> Void)? { get set }
    var onPeerConnected: ((UUID, String) -> Void)? { get set }
    var onPeerDisconnected: ((UUID) -> Void)? { get set }

    /// Stable id for the local device's own participant.
    var localParticipantID: UUID { get }

    func startHosting(roomID: String, nickname: String)
    func join(roomID: String, nickname: String)
    func send(_ message: SessionMessage)
    func stop()
}
