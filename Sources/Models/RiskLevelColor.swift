import SwiftUI

/// A green→red gradient with fixed saturation/brightness, so every level
/// in a risk scale is equally readable as a card background — system
/// colors (`.green`, `.red`, …) look fine as small icons but aren't
/// equally bright at full saturation, which made some selected cards
/// read as noticeably darker than others.
enum RiskLevelColor {
    static func color(level: Int, outOf count: Int) -> Color {
        let t = count > 1 ? Double(level) / Double(count - 1) : 0
        let hue = (1 - t) * 0.33
        return Color(hue: hue, saturation: 0.7, brightness: 0.85)
    }
}
