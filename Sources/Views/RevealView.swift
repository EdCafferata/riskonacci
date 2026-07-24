import SwiftUI

/// Full-screen reveal of the picked card — the moment the team compares
/// estimates, so it gets the loudest glass treatment in the app.
struct RevealView: View {
    let card: PokerCard
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                if let symbolName = card.symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: 64))
                        .foregroundStyle(card.tint)
                }
                Text(card.localizedLabel)
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
            }
            .padding(40)
            .glassEffect(.regular.tint(card.tint), in: .rect(cornerRadius: 32))

            Spacer()

            Button("Pick again", systemImage: "arrow.counterclockwise", action: onDismiss)
                .buttonStyle(.glassProminent)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
