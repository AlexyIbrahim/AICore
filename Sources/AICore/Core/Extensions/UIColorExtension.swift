//
//  UIColorExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import UIKit

public extension UIColor {
	convenience init?(hex: String) {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if cString.hasPrefix("#") {
			//                cString.remove(at: cString.startIndex)
			cString = cString.replacingOccurrences(of: "#", with: "")
		}
		
		if (cString.count) != 6 {
			return nil
		}
		
		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
	}
	
	// a darker function that returns the same button but darker, as if it has been clicked
	func darker(by percentage: CGFloat = 30.0) -> UIColor? {
		return self.adjust(by: -1 * abs(percentage) )
	}
	
	private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0
		
		if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
			return UIColor(red: min(red + percentage/100, 1.0),
						   green: min(green + percentage/100, 1.0),
						   blue: min(blue + percentage/100, 1.0),
						   alpha: alpha)
		} else {
			return nil
		}
	}
}
