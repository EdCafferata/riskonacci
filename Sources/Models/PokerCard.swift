import SwiftUI

struct PokerCard: Identifiable, Hashable {
    let label: String
    let symbolName: String?
    let tint: Color

    /// Stable, derived from the label rather than a fresh UUID — decks are
    /// recomputed on every access, so identity has to survive that or
    /// selection/highlight state breaks after the first render.
    var id: String { label }

    /// `label` alone (a plain `String`) skips Xcode's String Catalog
    /// lookup when passed to `Text`/`Label` — wrapping it in a
    /// `LocalizedStringKey` still performs the lookup even though the key
    /// itself is a runtime value, not a literal.
    var localizedLabel: LocalizedStringKey { LocalizedStringKey(label) }

    init(_ label: String, symbolName: String? = nil, tint: Color = .accentColor) {
        self.label = label
        self.symbolName = symbolName
        self.tint = tint
    }
}
