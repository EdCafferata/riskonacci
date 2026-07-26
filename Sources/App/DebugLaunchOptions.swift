#if DEBUG
import Foundation

/// A tiny testing hook: since Claude can't tap through the Simulator UI,
/// setting `RISKONACCI_AUTO_HOST_NAME` in the launch environment (e.g. via
/// `SIMCTL_CHILD_RISKONACCI_AUTO_HOST_NAME` on `simctl launch`) makes the
/// app skip straight to hosting a multiplayer room under that nickname, so
/// a real device can join it and the live networking can actually be
/// exercised.
enum DebugLaunchOptions {
    static var autoHostNickname: String? {
        ProcessInfo.processInfo.environment["RISKONACCI_AUTO_HOST_NAME"]
    }

    /// Set together with `RISKONACCI_AUTO_JOIN_ROOM` to skip straight to
    /// joining an existing room by code — lets multiple simulators wire
    /// themselves into the same session without any taps.
    static var autoJoinNickname: String? {
        ProcessInfo.processInfo.environment["RISKONACCI_AUTO_JOIN_NAME"]
    }

    static var autoJoinRoomID: String? {
        ProcessInfo.processInfo.environment["RISKONACCI_AUTO_JOIN_ROOM"]
    }
}
#endif
