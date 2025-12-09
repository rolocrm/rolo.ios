import SwiftUI

extension Font {
    static func figtree(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("Figtree", size: size).weight(weight)
    }
    
    static func figtreeBold(size: CGFloat) -> Font {
        return .custom("Figtree", size: size).weight(.bold)
    }
    
    static func figtreeMedium(size: CGFloat) -> Font {
        return .custom("Figtree", size: size).weight(.medium)
    }
    
    static func figtreeSemiBold(size: CGFloat) -> Font {
        return .custom("Figtree", size: size).weight(.semibold)
    }
    
    static func ebGaramond(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("EBGaramond", size: size).weight(weight)
    }
    
    static func ebGaramondMedium(size: CGFloat) -> Font {
        return .custom("EBGaramond", size: size).weight(.medium)
    }
}
