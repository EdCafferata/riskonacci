import Foundation

enum TipProduct: String, CaseIterable {
    case espresso = "info.cafferata.riskonacci.tip.espresso"
    case cornetto = "info.cafferata.riskonacci.tip.cornetto"
    case aperitivo = "info.cafferata.riskonacci.tip.aperitivo"

    var displayName: String {
        switch self {
        case .espresso: "Espresso"
        case .cornetto: "Cornetto"
        case .aperitivo: "Aperitivo"
        }
    }

    var symbolName: String {
        switch self {
        case .espresso: "cup.and.saucer.fill"
        case .cornetto: "takeoutbag.and.cup.and.straw.fill"
        case .aperitivo: "wineglass.fill"
        }
    }
}
