//
//  AIFont.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation
import UIKit

public struct AIFont {
    
    // internal resolved font
    private var resolvedFont: UIFont
    
    // returns font value
    public var font: UIFont { resolvedFont }
    
    /// Initialize ABFont with signle font
    /// - Parameters:
    ///   - font: font name
    public init(_ fontName: String, ofSize fontSize: AIFontSize = .size15) {
        resolvedFont = UIFont(name: fontName,
                              size: fontSize.getFontSize())!
    }
    
    public init(_ font: UIFont) {
        resolvedFont = font
    }
}
