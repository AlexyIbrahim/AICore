//
//  AIButtonStyle.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation

import UIKit

public enum AIButtonStyleCorner {
    case roundCorner
    case zeroRadius
    case customRoundCorner(corners: UIRectCorner, radius: CGFloat)
    case other(radius: CGFloat)
}

public enum AIButtonStyleHeight {
    case fixed(height: CGFloat)
    case custom
}

public struct AIButtonStyle {
    public var textColor: AIColor
    public var backgroundColor: AIColor
    public var highlightedBackgroundColor: AIColor?
    public var borderColor: AIColor?
    public var highlightedBorderColor: AIColor?
    public var heightType: AIButtonStyleHeight = .custom
    public var cornerStyle: AIButtonStyleCorner?
    public var borderWidth: CGFloat?
    public var loadingIndicatorStyle: UIActivityIndicatorView.Style?
    public var font: AIFont?
    public var contentInset: UIEdgeInsets?
    public var titleEdgeInset: UIEdgeInsets?
    public var enabled: Bool!

    public init(textColor: AIColor,
                backgroundColor: AIColor,
                highlightedBackgroundColor: AIColor? = nil,
                highlightedBorderColor: AIColor? = nil,
                heightType: AIButtonStyleHeight = .custom,
                cornerStyle: AIButtonStyleCorner? = nil,
                borderWidth: CGFloat? = nil,
                borderColor: AIColor? = nil,
                loadingIndicatorStyle: UIActivityIndicatorView.Style? = nil,
                font: AIFont? = nil,
                contentInset: UIEdgeInsets? = nil,
                titleEdgeInset: UIEdgeInsets? = nil,
                enabled: Bool? = nil)
    {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.highlightedBackgroundColor = highlightedBackgroundColor
        self.borderColor = borderColor
        self.highlightedBorderColor = highlightedBorderColor
        self.heightType = heightType
        self.cornerStyle = cornerStyle
        self.borderWidth = borderWidth
        self.loadingIndicatorStyle = loadingIndicatorStyle
        self.font = font
        self.contentInset = contentInset
        self.titleEdgeInset = titleEdgeInset
        self.enabled = enabled ?? true
    }
}
