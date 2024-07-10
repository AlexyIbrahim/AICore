//
//  MainColorTheme.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation

public class MainColorTheme {
	public var pureBlack: AIColor {AIColor.init(.black)}
	public var pureWhite: AIColor {AIColor.init(.white)}
	public var blackWhite: AIColor {AIColor.init(.black, dark: .white)}
	public var whiteBlack: AIColor {AIColor.init(.white, dark: .black)}
	public var error: AIColor {AIColor.init(.systemRed)}
	public var success: AIColor {AIColor.init(.systemGreen)}
	public var clear: AIColor {AIColor.init(.clear, dark: .clear)}
	public var lightGray: AIColor {AIColor.init(.systemGray6)}
}
