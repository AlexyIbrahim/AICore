//
//  AILabelStyle.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation
import UIKit

public struct AILabelStyle {
    public var textColor: AIColor
    public var font: AIFont

    public init(textColor: AIColor, font: AIFont) {
        self.textColor = textColor
        self.font = font
    }
	
    public init(textColor: AIColor, font: UIFont) {
        self.textColor = textColor
		self.font = AIFont.init(font)
    }
}
