import SwiftUI

// TODO: Check and update color names
extension Color {
    static let primaryBackground = Color(hex: "0F1F1C")
    static let errorRed = Color(hex: "E5655C")
    static let secondaryGreen = Color(hex: "142C28")
    static let highlightGreen = Color(hex: "66A636")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "5B6966")
    static let textFieldBackground = Color(hex: "142C28")
    static let googleButtonBackground = Color(hex: "0F1F1C")
    static let greyColor = Color(hex: "5B6966")
    static let disabledButtonBackground = Color(hex: "142C28")
    static let headerColor = Color(hex: "E0F0D5")
    static let primaryGreen = Color(hex: "0F1F1C")
    static let unselectedTabColor = Color(hex: "BBBBBB")
    static let buttonBackground = Color(hex: "E0F0D5")

    // TODO: - CHeck all colors
    static let neutralBlack = Color(hex: "1A1F1D")
    static let neutralLightGray = Color(hex: "F6F6F3")
    static let neutralDarkGray = Color(hex: "5B6966")
//    static let highlightGreen = Color(hex: "66A636")
    static let neutralMediumGray = Color(hex: "BBBBBB")
    static let brandSecondary = Color(hex: "142C28")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
