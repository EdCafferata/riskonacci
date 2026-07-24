import SwiftUI

struct RoomRevealView: View {
    @Bindable var room: MultiplayerRoomViewModel

    var body: some View {
        VStack(spacing: 20) {
            ParticipantsRow(room: room)
                .padding(.horizontal)
                .padding(.top, 12)

            Spacer()

            if room.isTwoRoundFlow {
                matrixReveal
            } else {
                listReveal
            }

            Spacer()

            if room.isHost {
                Button("New round", systemImage: "arrow.counterclockwise") {
                    room.resetRound()
                }
                .buttonStyle(.glassProminent)
                .font(.title3)
            }
        }
        .padding(.bottom, 24)
        .navigationTitle(room.selectedDeck.localizedName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var matrixReveal: some View {
        let dots: [RiskMatrixDot] = room.participants.compactMap { participant in
            guard let vote = room.votes[participant.id],
                  let likelihoodLabel = vote.likelihoodLabel,
                  let impactLabel = vote.impactLabel else { return nil }
            let likelihoodIndex = RiskAxis.likelihood.cards.firstIndex { $0.label == likelihoodLabel } ?? 0
            let impactIndex = RiskAxis.impact.cards.firstIndex { $0.label == impactLabel } ?? 0
            return RiskMatrixDot(
                id: participant.id,
                likelihoodIndex: likelihoodIndex,
                impactIndex: impactIndex,
                label: String(participant.nickname.prefix(1)).uppercased(),
                tint: Color.accentColor
            )
        }

        return RiskMatrixGrid(dots: dots)
            .frame(maxWidth: 340, maxHeight: 340)
            .padding(.horizontal)
    }

    private var listReveal: some View {
        GlassEffectContainer(spacing: 10) {
            VStack(spacing: 10) {
                ForEach(room.participants) { participant in
                    HStack {
                        Text(participant.nickname)
                            .font(.headline)
                        Spacer()
                        Text(LocalizedStringKey(room.votes[participant.id]?.singleLabel ?? "—"))
                            .font(.title3.bold())
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity)
    }
}
