//
//  UIImageViewExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/15/22.
//

import Foundation
import UIKit

public extension UIImage {
	static func fromText(_ text: String, font: UIFont? = nil, size: CGSize, textColor: UIColor = .black, backgroundColor: UIColor = .clear) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: size)
		
		let img = renderer.image { context in
			// Fill the background with the background color
			backgroundColor.setFill()
			context.fill(CGRect(origin: .zero, size: size))
			
			// Set up the attributes for the text
			let usedFont = font ?? UIFont.systemFont(ofSize: 17)
			let attributes: [NSAttributedString.Key: Any] = [
				.font: usedFont,
				.foregroundColor: textColor
			]
			
			// Determine the rectangle for the text to be drawn in
			let textRect = CGRect(origin: .zero, size: size)
			
			// Draw the text within the rectangle
			let textSize = text.size(withAttributes: attributes)
			let textOrigin = CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2)
			text.draw(at: textOrigin, withAttributes: attributes)
		}
		
		return img
	}
}
