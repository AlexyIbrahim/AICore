//
//  AIFontSize.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation

public enum AIFontSize: CGFloat {
    case size10 = 10.0
    case size12 = 12.0
    case size13 = 13.0
    case size15 = 15.0
    case size16 = 16.0
    case size17 = 17.0
}

public extension AIFontSize {
    
    /// Return font size
    /// - Parameter scaleFont: boolean value to return scaled font
    /// - Returns: font size
    func getFontSize() -> CGFloat {
        switch self {
        case .size10:
            return size10
        case .size12:
            return size12
        case .size13:
            return size13
        case .size15:
            return size15
        case .size16:
            return size16
        case .size17:
            return size17
        }
    }
}

public extension AIFontSize {
    var size10: CGFloat { AIFontSize.size10.rawValue }
    var size12: CGFloat { AIFontSize.size12.rawValue }
    var size13: CGFloat { AIFontSize.size13.rawValue }
    var size15: CGFloat { AIFontSize.size15.rawValue }
    var size16: CGFloat { AIFontSize.size16.rawValue }
    var size17: CGFloat { AIFontSize.size17.rawValue }
}
