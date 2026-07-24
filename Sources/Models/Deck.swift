import SwiftUI

enum Deck: String, CaseIterable, Identifiable, Codable {
    case fibonacci = "Fibonacci"
    case standard = "Standard"
    case tShirt = "T-Shirt"
    case risk = "Risk"

    var id: String { rawValue }

    /// `rawValue` is a plain `String`, used for identity/persistence — it
    /// does not get picked up by Xcode's String Catalog extraction. This is
    /// the localizable display name to actually show in the UI.
    var localizedName: LocalizedStringResource {
        switch self {
        case .fibonacci: "Fibonacci"
        case .standard: "Standard"
        case .tShirt: "T-Shirt"
        case .risk: "Risk"
        }
    }

    var symbolName: String {
        switch self {
        case .fibonacci: "number"
        case .standard: "textformat.123"
        case .tShirt: "tshirt"
        case .risk: "exclamationmark.triangle"
        }
    }

    var cards: [PokerCard] {
        switch self {
        case .fibonacci:
            ["0", "½", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89"].map {
                PokerCard($0)
            } + specialCards

        case .standard:
            ["0", "1", "2", "3", "5", "8", "13", "20", "40", "100"].map {
                PokerCard($0)
            } + specialCards

        case .tShirt:
            ["XS", "S", "M", "L", "XL", "XXL"].map {
                PokerCard($0)
            } + specialCards

        case .risk:
            riskCards + specialCards
        }
    }

    /// Riskonacci's differentiator: risk isn't just Fibonacci in a different
    /// color, it's a labeled low→critical scale so a team can see at a
    /// glance where the disagreement is, not just a spread of numbers.
    private var riskCards: [PokerCard] {
        let labels = ["None", "Low", "Medium", "High", "Critical"]
        let symbols = ["checkmark.circle", "1.circle", "2.circle", "3.circle", "flame"]
        return labels.indices.map { i in
            PokerCard(labels[i], symbolName: symbols[i], tint: RiskLevelColor.color(level: i, outOf: labels.count))
        }
    }

    private var specialCards: [PokerCard] {
        [
            PokerCard("?", symbolName: "questionmark.circle", tint: .secondary),
            PokerCard("☕", symbolName: "cup.and.saucer", tint: .brown),
        ]
    }
}
