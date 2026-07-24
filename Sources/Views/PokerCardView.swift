import SwiftUI

/// A single tappable card, rendered with the Liquid Glass material so it
/// reads as a physical object sitting above the background. Height is
/// driven by the grid (see `CardGridView`) so any deck size fits the
/// screen without scrolling.
struct PokerCardView: View {
    let card: PokerCard
    let isSelected: Bool
    /// True for single-column decks (Risk) — lays out icon + label as a
    /// left-aligned row instead of a centered stack, since a full-width
    /// card has room to spare and reads more like a list row.
    let isWide: Bool
    let height: CGFloat
    let action: () -> Void

    /// A selected card gets a tinted glass background — default text/icon
    /// colors can lose contrast against that, so selection forces white
    /// instead of relying on `.primary`.
    private var iconColor: Color { isSelected ? .white : card.tint }
    private var textColor: Color { isSelected ? .white : .primary }

    var body: some View {
        Button(action: action) {
            Group {
                if isWide {
                    HStack(spacing: 14) {
                        if let symbolName = card.symbolName {
                            Image(systemName: symbolName)
                                .font(.title2)
                                .foregroundStyle(iconColor)
                                .frame(width: 28)
                        }
                        Text(card.localizedLabel)
                            .font(.title3.bold())
                            .foregroundStyle(textColor)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 8) {
                        if let symbolName = card.symbolName {
                            Image(systemName: symbolName)
                                .font(.title2)
                                .foregroundStyle(iconColor)
                        }
                        Text(card.localizedLabel)
                            .font(.title3.bold())
                            .foregroundStyle(textColor)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: isWide ? .leading : .center)
            .frame(height: height)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(
            isSelected ? .regular.tint(card.tint).interactive() : .regular.interactive(),
            in: .rect(cornerRadius: 20)
        )
    }
}
