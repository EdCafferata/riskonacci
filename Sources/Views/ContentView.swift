import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            rootView
        }
        .fullScreenCover(isPresented: $viewModel.isRevealed) {
            if viewModel.isTwoRoundFlow,
               let likelihood = viewModel.likelihoodCard,
               let impact = viewModel.impactCard {
                RiskMatrixRevealView(likelihood: likelihood, impact: impact) {
                    viewModel.reset()
                }
            } else if let card = viewModel.selectedCard {
                RevealView(card: card) {
                    viewModel.reset()
                }
            }
        }
    }

    @ViewBuilder
    private var rootView: some View {
        #if DEBUG
        if DebugLaunchOptions.autoHostNickname != nil || DebugLaunchOptions.autoJoinNickname != nil {
            RoomEntryView()
        } else {
            DeckPickerView(viewModel: viewModel)
        }
        #else
        DeckPickerView(viewModel: viewModel)
        #endif
    }
}

#Preview {
    ContentView()
}
