import Foundation

/// A short, shareable room code — always 5 characters, letters + digits,
/// regardless of how many rooms have ever existed.
enum RoomID {
    /// O/0 and I/1 excluded — they're the pair people misread most often
    /// when reading a code off someone else's screen.
    private static let alphabet = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")

    static func generate() -> String {
        String((0..<5).map { _ in alphabet.randomElement()! })
    }

    static func isValid(_ code: String) -> Bool {
        let normalized = code.uppercased()
        guard normalized.count == 5 else { return false }
        return normalized.allSatisfy { alphabet.contains($0) }
    }
}
