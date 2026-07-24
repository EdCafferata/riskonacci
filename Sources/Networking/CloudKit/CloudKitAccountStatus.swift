import CloudKit

/// Online rooms need an active iCloud sign-in on the device (CloudKit's
/// public database still attributes writes to the signed-in account, even
/// though nothing app-specific is stored in iCloud itself — see the
/// privacy note on `CloudKitSessionTransport`). Checked upfront so a
/// missing sign-in shows a clear message instead of requests silently
/// failing one by one during the room's poll loop.
enum CloudKitAccountStatus {
    static func isAvailable() async -> Bool {
        (try? await CKContainer(identifier: CloudKitSessionTransport.containerIdentifier).accountStatus()) == .available
    }
}
