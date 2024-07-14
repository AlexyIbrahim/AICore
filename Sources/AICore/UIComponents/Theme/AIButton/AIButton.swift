//
//  AIButton.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Combine
import Foundation
import SnapKit
import UIKit

public extension AIButton {
    enum SideIconPosition {
        case left
        case right
    }

    struct SideIconUIModel {
        var icon: UIImage
        var iconPosition: SideIconPosition
        var edgeInsets: UIEdgeInsets

        public init(icon: UIImage,
                    iconPosition: SideIconPosition = .left,
                    edgeInsets: UIEdgeInsets? = nil)
        {
            self.icon = icon
            self.iconPosition = iconPosition

            self.edgeInsets = edgeInsets ?? UIEdgeInsets(top: 0,
                                                         left: iconPosition == .right ? 15 : 0,
                                                         bottom: 0,
                                                         right: iconPosition == .right ? 0 : 15)
        }
    }
}

public class AIButton: UIButton {
    public private(set) var sideIconModel: SideIconUIModel?
//    public private(set) var style: AIButtonStyle?

    private var _isLoading: Bool! = false
    public var isLoading: Bool! {
        return _isLoading
    }

    private var isLoadingCombine = PassthroughSubject<Bool, Never>()
    private var observers: [AnyCancellable] = []
    private lazy var aiActivityIndicator: AIActivityIndicator = {
        let indicator = AIActivityIndicator()
        return indicator
    }()

    private var buttonTitle: String?
    private var activityIndicatorTintColor: AIColor?

    public var badgeValue: String! = "" {
        didSet {
            layoutSubviews()
        }
    }

    public var style: AIButtonStyle? {
        didSet {
            applyStyle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override public func awakeFromNib() {
        commonInit()
        drawBadgeLayer()
    }

    func commonInit() {
        applyStyle()

        observers.removeAll()
        isLoadingCombine.eraseToAnyPublisher().sink { [weak self] isLoading in
            guard let self = self else { return }
            _isLoading = isLoading

            if isLoading {
                buttonTitle = self.title(for: .normal)
                self.setTitle("", for: .normal)

                self.aiActivityIndicator.showActivityIndicator(centeredWithView: self, activityIndicatorStyle: .none, tintColor: self.activityIndicatorTintColor?.color)

                self.isUserInteractionEnabled = false
            } else {
                self.aiActivityIndicator.stopAnimating()

                self.setTitle(buttonTitle, for: .normal)
                buttonTitle = nil

                self.isUserInteractionEnabled = true
            }
        }.store(in: &observers)
    }

    public func setStyle(_ style: AIButtonStyle) {
        self.style = style
    }

    private func applyStyle() {
//        self.font = self.style.font.font
        updateStyle()

//        self.setTitleColor(.white, for: .normal)
//        self.backgroundColor = self.style.backgroundColor.color
//
//        switch self.style.cornerStyle {
//        case .roundCorner:
//            self.layer.cornerRadius = 8
//        case .zeroRadius:
//            self.layer.cornerRadius = 0
//        case .customRoundCorner(corners: let corners, radius: let radius):
//            self.layer.cornerRadius = radius
//        case .other(radius: let radius):
//            self.layer.cornerRadius = radius
//        }
    }

    public func setSideIcon(_ sideIconModel: SideIconUIModel) {
        self.sideIconModel = sideIconModel
        setSideIcon()
    }

    /// This method/function was designed & implemented to: set a side icon
    private func setSideIcon() {
        guard let style = style else { return }

        guard let iconModel = sideIconModel else { return }
        setImage(iconModel.icon, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        tintColor = style.textColor.color
        imageEdgeInsets = iconModel.edgeInsets
        semanticContentAttribute = iconModel.iconPosition == .right ? .forceRightToLeft : .forceLeftToRight
    }

    public func setLoading(_ isLoading: Bool) {
        isLoadingCombine.send(isLoading)
    }

    public func setActivityIndicatorTintColor(_ aicolor: AIColor) {
        activityIndicatorTintColor = aicolor
    }

    /// This method/function was designed & implemented to: update the button's style
    private func updateStyle() {
        guard let style = style else { return }

        setTitleColor(style.textColor.color, for: .normal)
        setTitleColor(style.textColor.color, for: .highlighted)
        tintColor = style.textColor.color

        backgroundColor = style.backgroundColor.color

        switch style.cornerStyle {
        case .roundCorner:
            layer.cornerRadius = bounds.height / 2.0
        case .zeroRadius:
            layer.cornerRadius = 0
        case let .customRoundCorner(corners, radius):
            layer.cornerRadius = radius
        case let .other(radius):
            layer.cornerRadius = radius
        default:
            layer.cornerRadius = 0
        }

        if #available(iOS 15.0, *) {
            if let font = style.font?.font {
                if var configuration = self.configuration {
                    var container = AttributeContainer()
                    container.font = font
                    configuration.attributedTitle = AttributedString(self.title(for: .normal) ?? "", attributes: container)
                    self.configuration = configuration
                } else {
                    titleLabel?.font = font
                }

                //            if self.configuration == nil
                //            if var configuration = self.configuration {
                //                var container = AttributeContainer()
                //                container.font = font
                //                configuration.attributedTitle = AttributedString(self.title(for: .normal) ?? "", attributes: container)
                //                self.configuration = nil
                //            } else {
                //                self.setTitle(title(for: .normal), for: .normal)
                //            }
            }
        }

        if let borderColor = style.borderColor {
            layer.borderColor = style.borderColor?.color.cgColor
        }

        if let borderWidth = style.borderWidth {
            layer.borderWidth = borderWidth
        }
//        updateHeight()

        contentEdgeInsets = style.contentInset ?? .zero
        guard let titleInset = style.titleEdgeInset else { return }
//        if #available(iOS 15.0, *) {
//            if let font = style.font?.font {
//                if var configuration = self.configuration {
//                    var container = AttributeContainer()
//                    container.font = font
//                    configuration.attributedTitle = AttributedString(self.title(for: .normal) ?? "", attributes: container)
        ////                    configuration.title = title(for: .normal)
//
//                    configuration.baseBackgroundColor = style.backgroundColor.color
//                    configuration.titlePadding = titleInset.left
//                    configuration.contentInsets = NSDirectionalEdgeInsets(top: titleInset.top,
//                                                                          leading: titleInset.left,
//                                                                          bottom: titleInset.bottom,
//                                                                          trailing: titleInset.right)
//                    self.configuration = configuration
//                } else {
//                    titleLabel?.font = font
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }

        isEnabled = style.enabled
    }

    private func updateHeight() {
        guard let style = style else { return }

        if case let .fixed(height) = style.heightType {
            for constraint in constraints {
                if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                    constraint.constant = height
                }
                if constraint.firstAttribute == NSLayoutConstraint.Attribute.width, let contentInset = style.contentInset {
                    let insetWidth = contentInset.left + contentInset.right
                    constraint.constant = intrinsicContentSize.width + insetWidth
                }
            }
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let style = style else { return }

        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = style.borderColor?.color.cgColor
    }

    public func click() {
        sendActions(for: .touchUpInside)
    }

//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        if let style = style, let backgroundGradient = style.backgroundGradient {
//            let lightColor = backgroundGradient.light?.getColor(frame: bounds) ?? style.backgroundColor.light
//            let darkColor = backgroundGradient.dark?.getColor(frame: bounds) ?? style.backgroundColor.dark
//            self.style?.backgroundColor = ABColor(lightColor, dark: darkColor)
//        }
//        backgroundColor = style.backgroundColor.color
//
//        switch style.cornerStyle {
//        case .roundCorner:
//            layer.cornerRadius = bounds.height / 2.0
//        case .zeroRadius:
//            layer.cornerRadius = 0
//        case .customRoundCorner(let corners, let radius):
//            roundCorners(corners, radius: radius)
//        case .other(let radius):
//            layer.cornerRadius = radius
//        default:
//            layer.cornerRadius = 0
//        }
//    }

    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
    }

//    override func setTitle(_ title: String?, for state: UIControl.State) {
//        super.setTitle(title, for: state)
//        self.applyStyle()
//    }

    var badgeLayer: CAShapeLayer!
    func drawBadgeLayer() {
        if badgeLayer != nil {
            badgeLayer.removeFromSuperlayer()
        }

        // Omit layer if text is nil
        if badgeValue == nil || badgeValue.count == 0 {
            return
        }

        //! Initial label text layer
        let labelText = CATextLayer()
        labelText.contentsScale = UIScreen.main.scale
        labelText.string = badgeValue
        labelText.fontSize = 9.0
        labelText.font = UIFont.systemFont(ofSize: 9)
        labelText.alignmentMode = CATextLayerAlignmentMode.center
        labelText.foregroundColor = UIColor.white.cgColor
        let labelString = badgeValue.uppercased() as String?
        let labelFont = UIFont.systemFont(ofSize: 9) as UIFont?
        let attributes = [NSAttributedString.Key.font: labelFont]
        let w = self.frame.size.width
        let h = CGFloat(10.0) // fixed height
        let labelWidth = min(w * 0.8, 10.0) // Starting point
        let rect = labelString!.boundingRect(with: CGSize(width: labelWidth, height: h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let textWidth = round(rect.width * UIScreen.main.scale)
        labelText.frame = CGRect(x: 0, y: 0, width: textWidth, height: h)

        //! Initialize outline, set frame and color
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        let frame: CGRect = labelText.frame
        let cornerRadius = CGFloat(5.0)
        let borderInset = CGFloat(-1.0)
        let aPath = UIBezierPath(roundedRect: frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)

        shapeLayer.path = aPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 0.5

        shapeLayer.insertSublayer(labelText, at: 0)

        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: w * 0.5, dy: 0.0)

        layer.insertSublayer(shapeLayer, at: 999)
        layer.masksToBounds = false
        badgeLayer = shapeLayer
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        drawBadgeLayer()
        setNeedsDisplay()
    }
}
