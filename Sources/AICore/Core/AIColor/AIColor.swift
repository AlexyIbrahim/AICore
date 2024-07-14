//
//  AIColor.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/14/22.
//

import Foundation
import UIKit

public struct AIColor {
	// internal resolved color
	private var resolvedColor: UIColor
	
	// returns uicolor value
	public var color: UIColor { resolvedColor }
	// returns light uicolor value
	public var light: UIColor
	// returns dark uicolor value
	public var dark: UIColor
	
	// use UIColor's extension darker
	public var darker: UIColor? {
		resolvedColor.darker()
	}
	
	public init(_ color: UIColor, dark: UIColor? = nil) {
		resolvedColor = color
		if #available(iOS 13.0, *) {
			self = AIColor { trait -> UIColor in
				if trait.userInterfaceStyle == .dark {
					return dark ?? color
				}
				return color
			}
		} else {
			resolvedColor = color
		}
		light = color
		self.dark = dark ?? color
	}
	
	public init(_ colorHex: String, darkHex: String? = nil) {
		let color: UIColor! = UIColor(hex: colorHex)!
		let dark: UIColor? = (darkHex != nil) ? UIColor(hex: darkHex!)! : nil
		
		resolvedColor = color
		if #available(iOS 13.0, *) {
			self = AIColor { trait -> UIColor in
				if trait.userInterfaceStyle == .dark {
					return dark ?? color
				}
				return color
			}
		} else {
			resolvedColor = color
		}
		light = color
		self.dark = dark ?? color
	}
	
	public init(_ named: String) {
		let color: UIColor! = UIColor(named: named)!
		resolvedColor = color
		if #available(iOS 13.0, *) {
			self = AIColor.init { _ in
				color
			}
		} else {
			resolvedColor = color
		}
		light = color
		dark = color
	}
	
	/// Initialize ColorAsset with a dynamic trait
	/// - Parameter dynamic: A block that determines the appropriate color values based on the specified traits.
	/// This block returns a UIColor object and takes a single parameter traits
	private init(_ dynamic: @escaping (_ trait: UITraitCollection) -> UIColor) {
		if #available(iOS 13.0, *) {
			resolvedColor = UIColor { trait -> UIColor in
				dynamic(trait)
			}
		} else {
			resolvedColor = dynamic(UITraitCollection())
		}
		light = .clear
		dark = .clear
	}
}
