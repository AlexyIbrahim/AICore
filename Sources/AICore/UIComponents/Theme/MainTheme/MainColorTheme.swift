//
//  MainColorTheme.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation

public class MainColorTheme {
    public var pureBlack: AIColor { AIColor(.black) }
    public var pureWhite: AIColor { AIColor(.white) }
    public var blackWhite: AIColor { AIColor(.black, dark: .white) }
    public var whiteBlack: AIColor { AIColor(.white, dark: .black) }
    public var error: AIColor { AIColor(.systemRed) }
    public var success: AIColor { AIColor(.systemGreen) }
    public var clear: AIColor { AIColor(.clear, dark: .clear) }
    public var lightGray: AIColor { AIColor(.systemGray6) }
}
