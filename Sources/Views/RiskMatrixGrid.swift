import SwiftUI

struct RiskMatrixDot: Identifiable {
    let id: String
    let likelihoodIndex: Int
    let impactIndex: Int
    /// A short label (e.g. an initial) shown inside the dot — used in the
    /// multiplayer reveal so several dots on the same matrix stay
    /// distinguishable. Nil for the solo reveal's single anonymous dot.
    let label: String?
    let tint: Color
}

/// A 5×5 risk matrix: likelihood on the x-axis, impact on the y-axis,
/// green→red by magnitude. Takes one dot (solo reveal) or several
/// (multiplayer — one per participant).
struct RiskMatrixGrid: View {
    let dots: [RiskMatrixDot]

    private let size = 5

    init(likelihoodIndex: Int, impactIndex: Int) {
        dots = [RiskMatrixDot(id: UUID().uuidString, likelihoodIndex: likelihoodIndex, impactIndex: impactIndex, label: nil, tint: .white)]
    }

    init(dots: [RiskMatrixDot]) {
        self.dots = dots
    }

    var body: some View {
        GeometryReader { geo in
            let cell = min(geo.size.width, geo.size.height) / CGFloat(size)

            ZStack(alignment: .topLeading) {
                ForEach(0..<size, id: \.self) { row in
                    ForEach(0..<size, id: \.self) { col in
                        Rectangle()
                            .fill(color(row: row, col: col))
                            .frame(width: cell, height: cell)
                            .position(x: CGFloat(col) * cell + cell / 2, y: CGFloat(row) * cell + cell / 2)
                    }
                }

                ForEach(dots) { dot in
                    dotView(dot, cell: cell)
                        .position(
                            x: CGFloat(dot.likelihoodIndex) * cell + cell / 2,
                            y: CGFloat(size - 1 - dot.impactIndex) * cell + cell / 2
                        )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 20))
    }

    @ViewBuilder
    private func dotView(_ dot: RiskMatrixDot, cell: CGFloat) -> some View {
        let diameter = cell * 0.5
        Group {
            if let label = dot.label {
                Text(label)
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .frame(width: diameter, height: diameter)
                    .background(dot.tint, in: .circle)
            } else {
                Circle()
                    .fill(.white)
                    .frame(width: diameter, height: diameter)
            }
        }
        .glassEffect(.regular, in: .circle)
    }

    /// row 0 is the top of the grid (highest impact), col 0 is the left
    /// (lowest likelihood) — standard risk-matrix orientation.
    private func color(row: Int, col: Int) -> Color {
        let impactLevel = size - 1 - row
        let likelihoodLevel = col
        let magnitude = Double((impactLevel + 1) * (likelihoodLevel + 1)) / Double(size * size)
        return Color(hue: (1 - magnitude) * 0.33, saturation: 0.75, brightness: 0.9)
    }
}
