import Foundation

/// Abstraction over "how devices in a room talk to each other." Firebase
/// is the only implementation (`FirebaseSessionTransport`) — both the
/// local-network mesh (MultipeerConnectivity) and CloudKit-signaled
/// online rooms were retired in favor of one shared backend that works
/// identically for local and remote play, and interoperates with the
/// Android app.
///
/// Participant identity is a plain `String` (Firebase Auth's own UID
/// format), not a `UUID` — there's no more Apple-only transport that
/// needs Foundation's `UUID` type specifically.
@MainActor
protocol SessionTransport: AnyObject {
    var onReceive: ((SessionMessage, String) -> Void)? { get set }
    var onPeerConnected: ((String, String) -> Void)? { get set }
    var onPeerDisconnected: ((String) -> Void)? { get set }

    /// Stable id for the local device's own participant.
    var localParticipantID: String { get }

    func startHosting(roomID: String, nickname: String)
    func join(roomID: String, nickname: String)
    func send(_ message: SessionMessage)
    func stop()
}
