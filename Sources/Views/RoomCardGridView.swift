import SwiftUI

/// Multiplayer equivalent of `CardGridView`, bound to `MultiplayerRoomViewModel`
/// instead of the solo `GameViewModel` — the state shapes differ enough
/// (per-participant votes, round tracked per player) that sharing one view
/// between solo and room modes would need more indirection than it's worth
/// right now.
struct RoomCardGridView: View {
    @Bindable var room: MultiplayerRoomViewModel

    private let spacing: CGFloat = 14
    private let outerPadding: CGFloat = 16
    private let titleGap: CGFloat = 20

    private var columnCount: Int {
        room.selectedDeck == .risk ? 1 : 2
    }

    private var cards: [PokerCard] {
        guard room.isTwoRoundFlow, let localID = room.localParticipantID else {
            return room.selectedDeck.cards
        }
        let round = room.currentRound(for: localID) ?? .likelihood
        return round == .likelihood ? RiskAxis.likelihood.cards : RiskAxis.impact.cards
    }

    private var localCardLabel: String? {
        guard let localID = room.localParticipantID, let vote = room.votes[localID] else { return nil }
        guard room.isTwoRoundFlow else { return vote.singleLabel }
        let round = room.currentRound(for: localID) ?? .likelihood
        return round == .likelihood ? vote.likelihoodLabel : vote.impactLabel
    }

    // See CardGridView — same fix, same reasoning: uncapped, a handful of
    // cards on an iPad-sized screen turns into oversized rectangles.
    private var maxCardHeight: CGFloat { columnCount == 1 ? 90 : 160 }
    private let maxGridWidth: CGFloat = 700

    var body: some View {
        VStack(spacing: 0) {
            ParticipantsRow(room: room)
                .padding(.horizontal)
                .padding(.top, 12)

            GeometryReader { geo in
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
                                isSelected: localCardLabel == card.label,
                                isWide: columnCount == 1,
                                height: cardHeight
                            ) {
                                room.pick(card)
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
        }
        .navigationTitle(Text(room.isTwoRoundFlow ? currentRoundTitle : room.selectedDeck.localizedName))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if room.canGoBack {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "chevron.left") {
                        room.goBack()
                    }
                }
            }
        }
    }

    private var currentRoundTitle: LocalizedStringResource {
        guard let localID = room.localParticipantID else { return room.selectedDeck.localizedName }
        let round = room.currentRound(for: localID) ?? .likelihood
        return round == .likelihood ? RiskAxis.likelihood.localizedName : RiskAxis.impact.localizedName
    }
}
