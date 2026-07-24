import SwiftUI

/// A compact strip of chips, one per participant, showing who's voted —
/// not what they voted, that stays hidden until the host reveals.
struct ParticipantsRow: View {
    let room: MultiplayerRoomViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(room.participants) { participant in
                    chip(for: participant)
                }
            }
        }
    }

    private func chip(for participant: SessionParticipant) -> some View {
        HStack(spacing: 4) {
            if room.hostID == participant.id {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
            }
            Text(participant.nickname)
                .font(.caption.bold())
            Image(systemName: room.hasVoted(participant.id) ? "checkmark.circle.fill" : "circle.dotted")
                .font(.caption2)
                .foregroundStyle(room.hasVoted(participant.id) ? .green : .secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .glassEffect(.regular, in: .capsule)
    }
}
