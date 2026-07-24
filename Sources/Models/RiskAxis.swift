import SwiftUI

/// The two-round "Risk Poker" scale (TMAP-style): likelihood and impact are
/// voted on separately, then combined into a position on a risk matrix.
/// Distinct from the single-card Risk deck in `Deck.swift`.
enum RiskAxis: String {
    case likelihood = "Likelihood"
    case impact = "Impact"

    var localizedName: LocalizedStringResource {
        switch self {
        case .likelihood: "Likelihood"
        case .impact: "Impact"
        }
    }

    var cards: [PokerCard] {
        let labels: [String]
        let symbolPrefix: String

        switch self {
        case .likelihood:
            labels = ["Rare", "Unlikely", "Possible", "Likely", "Almost Certain"]
            symbolPrefix = "circle"
        case .impact:
            labels = ["Negligible", "Minor", "Moderate", "Major", "Catastrophic"]
            symbolPrefix = "square"
        }

        return labels.indices.map { i in
            PokerCard(
                labels[i],
                symbolName: "\(i + 1).\(symbolPrefix)",
                tint: RiskLevelColor.color(level: i, outOf: labels.count)
            )
        }
    }

    /// 0-based index of a card within this axis's scale, used to place it
    /// on the risk matrix. Falls back to 0 (lowest) if the card isn't
    /// actually one of this axis's cards.
    func index(of card: PokerCard) -> Int {
        cards.firstIndex(of: card) ?? 0
    }
}
