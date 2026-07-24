import SwiftUI

struct CardGridView: View {
    @Bindable var viewModel: GameViewModel

    private let spacing: CGFloat = 14
    private let outerPadding: CGFloat = 16
    private let titleGap: CGFloat = 20

    // Risk (both the single Risk deck and the Likelihood/Impact rounds) is
    // an ordered ladder — None→Low→Medium→High→Critical — so it reads
    // better as one column than as a 2-wide grid.
    private var columnCount: Int {
        viewModel.selectedDeck == .risk ? 1 : 2
    }

    // On iPad-sized screens, dividing all available height/width across a
    // handful of cards makes them absurdly large — cap how big a single
    // card is allowed to get, and center the (now narrower) grid instead
    // of stretching it edge to edge.
    private var maxCardHeight: CGFloat { columnCount == 1 ? 90 : 160 }
    private let maxGridWidth: CGFloat = 700

    var body: some View {
        GeometryReader { geo in
            let cards = viewModel.currentCards
            let columnCount = columnCount
            let rowCount = max(Int(ceil(Double(cards.count) / Double(columnCount))), 1)
            let verticalSpacing = spacing * CGFloat(rowCount - 1)
            let availableHeight = geo.size.height - outerPadding * 2 - titleGap - verticalSpacing
            let cardHeight = min(max(availableHeight / CGFloat(rowCount), 60), maxCardHeight)

            let columns = Array(
                repeating: GridItem(.flexible(), spacing: spacing),
                count: columnCount
            )

            GlassEffectContainer(spacing: spacing) {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(cards) { card in
                        PokerCardView(
                            card: card,
                            isSelected: viewModel.isSelected(card),
                            isWide: columnCount == 1,
                            height: cardHeight
                        ) {
                            viewModel.pick(card)
                        }
                    }
                }
                .padding(.horizontal, outerPadding)
                .padding(.bottom, outerPadding)
                .padding(.top, outerPadding + titleGap)
                .frame(maxWidth: maxGridWidth)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(Text(viewModel.currentTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.canGoBack {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "chevron.left") {
                        viewModel.goBack()
                    }
                }
            }
            if viewModel.selectedDeck == .risk {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.twoRoundsEnabled.toggle()
                    } label: {
                        Label(
                            "2 rounds",
                            systemImage: viewModel.twoRoundsEnabled ? "checkmark.circle.fill" : "circle"
                        )
                    }
                    .buttonStyle(.glass)
                }
            }
        }
        .onChange(of: viewModel.twoRoundsEnabled) { _, _ in
            viewModel.reset()
        }
    }
}
