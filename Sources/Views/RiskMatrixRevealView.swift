import SwiftUI

/// The combined reveal for the two-round Risk flow: Likelihood and Impact
/// are shown together as one point on a risk matrix, not as two separate
/// reveals — that was the whole point of doing two rounds in the first
/// place.
struct RiskMatrixRevealView: View {
    let likelihood: PokerCard
    let impact: PokerCard
    let onDismiss: () -> Void

    private var likelihoodIndex: Int { RiskAxis.likelihood.index(of: likelihood) }
    private var impactIndex: Int { RiskAxis.impact.index(of: impact) }
    private var magnitude: Int { (likelihoodIndex + 1) * (impactIndex + 1) }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Risk Matrix")
                .font(.title2.bold())

            HStack(spacing: 8) {
                Text("Impact")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 20)

                RiskMatrixGrid(likelihoodIndex: likelihoodIndex, impactIndex: impactIndex)
                    .frame(maxWidth: 320, maxHeight: 320)
            }
            Text("Likelihood")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 32) {
                axisSummary(title: "Likelihood", card: likelihood)
                axisSummary(title: "Impact", card: impact)
            }
            .padding(.top, 8)

            Text("Magnitude \(magnitude)")
                .font(.title3.bold())

            Spacer()

            Button("Pick again", systemImage: "arrow.counterclockwise", action: onDismiss)
                .buttonStyle(.glassProminent)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func axisSummary(title: LocalizedStringKey, card: PokerCard) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Label(card.localizedLabel, systemImage: card.symbolName ?? "")
                .font(.headline)
                .foregroundStyle(card.tint)
        }
    }
}
