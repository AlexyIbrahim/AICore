//
//  File.swift
//
//
//  Created by Alexy Ibrahim on 2/25/23.
//

import Foundation

public extension AIColor {
	static var pureBlack: AIColor { ThemeManager.shared.current.color.pureBlack }
	static var pureWhite: AIColor { ThemeManager.shared.current.color.pureWhite }
	static var blackWhite: AIColor { ThemeManager.shared.current.color.blackWhite }
	static var whiteBlack: AIColor { ThemeManager.shared.current.color.whiteBlack }
	static var error: AIColor { ThemeManager.shared.current.color.error }
	static var success: AIColor { ThemeManager.shared.current.color.success }
	static var clear: AIColor { ThemeManager.shared.current.color.clear }
	static var lightGray: AIColor { ThemeManager.shared.current.color.lightGray }
}
