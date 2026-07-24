import SwiftUI

struct DeckPickerView: View {
    @Bindable var viewModel: GameViewModel
    @State private var showsTipJar = false

    var body: some View {
        List {
            titleRow
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            ForEach(Deck.allCases.filter { $0 != .risk }) { deck in
                Section {
                    deckRow(deck)
                }
            }

            Color.clear
                .frame(height: 20)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            Section {
                deckRow(.risk)
            }

            Section {
                NavigationLink {
                    RoomEntryView()
                } label: {
                    Label("Play together", systemImage: "person.2.fill")
                        .font(.title3)
                        .padding(.vertical, 6)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Deck.self) { deck in
            CardGridView(viewModel: viewModel)
                .onAppear { viewModel.chooseDeck(deck) }
        }
        .sheet(isPresented: $showsTipJar) {
            TipJarView()
        }
    }

    /// A custom title row instead of the system large title, so the tip
    /// jar button can sit at the exact same height as "Riskonacci" — the
    /// system nav bar's toolbar area and the large title live in separate
    /// rows that can't be vertically aligned against each other.
    private var titleRow: some View {
        HStack(alignment: .center) {
            Text("Riskonacci")
                .font(.largeTitle.bold())
            Spacer()
            Button {
                showsTipJar = true
            } label: {
                Image(systemName: "heart")
            }
            .buttonStyle(.glass)
        }
        .padding(.top, 20)
    }

    private func deckRow(_ deck: Deck) -> some View {
        NavigationLink(value: deck) {
            Label(String(localized: deck.localizedName), systemImage: deck.symbolName)
                .font(.title3)
                .padding(.vertical, 6)
        }
    }
}
