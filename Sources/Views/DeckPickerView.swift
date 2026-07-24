import SwiftUI

struct DeckPickerView: View {
    @Bindable var viewModel: GameViewModel
    @State private var showsTipJar = false

    var body: some View {
        List {
            Color.clear
                .frame(height: 20)
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
        .navigationTitle("Riskonacci")
        .navigationDestination(for: Deck.self) { deck in
            CardGridView(viewModel: viewModel)
                .onAppear { viewModel.chooseDeck(deck) }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showsTipJar = true
                } label: {
                    Image(systemName: "heart")
                }
            }
        }
        .sheet(isPresented: $showsTipJar) {
            TipJarView()
        }
    }

    private func deckRow(_ deck: Deck) -> some View {
        NavigationLink(value: deck) {
            Label(String(localized: deck.localizedName), systemImage: deck.symbolName)
                .font(.title3)
                .padding(.vertical, 6)
        }
    }
}
