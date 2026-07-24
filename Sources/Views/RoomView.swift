import SwiftUI

struct RoomView: View {
    @Bindable var room: MultiplayerRoomViewModel

    var body: some View {
        VStack(spacing: 0) {
            roomCodeBar

            if room.isHost {
                hostControls
            }

            if room.isRevealed {
                RoomRevealView(room: room)
            } else {
                RoomCardGridView(room: room)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Leave", role: .destructive) {
                    room.leave()
                }
            }
        }
    }

    private var roomCodeBar: some View {
        HStack(spacing: 6) {
            Text("Room")
                .foregroundStyle(.secondary)
            Text(room.roomID)
                .font(.headline.monospaced())
            if room.connectionState == .connecting {
                ProgressView()
                    .padding(.leading, 4)
            }
            ShareLink(item: shareMessage) {
                Label("Share code", systemImage: "square.and.arrow.up")
                    .labelStyle(.iconOnly)
            }
            .padding(.leading, 4)
        }
        .font(.subheadline)
        .padding(.top, 8)
    }

    /// One tap to hand someone the room code via AirDrop/Messages/etc,
    /// instead of them having to be told the code and type it in — most
    /// useful for the nearby (Wi-Fi/Bluetooth) mode when everyone's already
    /// in the same room.
    private var shareMessage: String {
        String(localized: "Join my Riskonacci room:") + " " + room.roomID
    }

    private var hostControls: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Menu {
                    ForEach(Deck.allCases) { deck in
                        Button(String(localized: deck.localizedName)) {
                            room.selectDeck(deck)
                        }
                    }
                } label: {
                    Label(String(localized: room.selectedDeck.localizedName), systemImage: room.selectedDeck.symbolName)
                }
                .buttonStyle(.glass)

                if room.selectedDeck == .risk {
                    Button {
                        room.setTwoRoundsEnabled(!room.twoRoundsEnabled)
                    } label: {
                        Label(
                            "2 rounds",
                            systemImage: room.twoRoundsEnabled ? "checkmark.circle.fill" : "circle"
                        )
                    }
                    .buttonStyle(.glass)
                }

                Button("Reset", systemImage: "arrow.counterclockwise") {
                    room.resetRound()
                }
                .buttonStyle(.glass)

                Button("Reveal", systemImage: "eye") {
                    room.reveal()
                }
                .buttonStyle(.glassProminent)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
