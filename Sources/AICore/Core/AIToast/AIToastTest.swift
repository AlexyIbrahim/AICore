
import UIKit

public class AIToastTest {
    private static let dashView = UIView()
    // PLAIN LOAF UTILITIES
    private static var plainLoafView = UIView()
    private static var plainLoafLabel = UILabel()
    private static var plainLoafImageView = UIImageView()
    // GRADIENT LOAF UTILITIES
    private static var gradientLoafView = UIView()
    private static var gradientLoafLabel = UILabel()
    private static var gradientLoafImageView = UIImageView()
    // POPUPCARD UTILITIES
    private static let popUpCardView = UIView()
    private static let popUpCardLabel = UILabel()
    private static let popUpCardImageView = UIImageView()
    // LOAFWHEEL UTILITIES
    private static let loafWheelView = UIView()
    private static let loafWheelLabel = UILabel()
    private static let wheel = UIActivityIndicatorView()
    public static let visualEffect = UIVisualEffectView()
    // DASH LOAF UTILITIES
    private static var dashSpacingCopy: CGFloat = 0 // Passing on spacing to @objc func
    // public static let dashButton = UIButton()

    // MARK: - Plain Loaf Method

    /// Plain Loaf is a Loaf view with custom background and various position placement option.
    /// - Parameters:
    ///   - message: Message to show on Loaf
    ///   - position: Where to place the Loaf
    ///   - loafWidth: Width of Loaf
    ///   - loafHeight: Height of Loaf
    ///   - cornerRadius: CornerRadius of Loaf
    ///   - fontStyle: Font style of Loaf
    ///   - fontSize: Font size of Loaf
    ///   - fontColor: Font colour of Loaf
    ///   - bgColor: Background colour of  Loaf
    ///   - loafImage: Image to show on Loaf
    ///   - animationDirection: Loaf Animation Direction
    ///   - duration: Animation Duration
    ///   - loafjetView: UIView on which the Loaf is to be presented
    ///   - alphaValue: The opacity value of the background colour parameter, specified as a value from 0.0 to 1.0

    public static func plainLoaf(message: String, position: LoafPosition, loafWidth: CGFloat? = nil, loafHeight: CGFloat? = nil, cornerRadius: CGFloat? = nil, fontStyle: String? = nil, fontSize: CGFloat? = nil, bgColor: UIColor? = nil, fontColor: UIColor? = nil, alphaValue: CGFloat? = nil, loafImage: String? = nil, animationDirection: LoafAnimation, duration: TimeInterval? = nil, offset: CGFloat? = nil) {
        let loafWidth = loafWidth ?? 240
        let loafHeight = loafHeight ?? 40
        let cornerRadius = cornerRadius ?? 20
        let fontStyle = fontStyle ?? "Avenir-Medium"
        let fontSize = fontSize ?? 17
        let bgColor = bgColor ?? .black
        let fontColor = fontColor ?? .darkGray
        let alphaValue = alphaValue ?? 1.0
        let loafImage = loafImage ?? ""
        let duration = duration ?? 3.0

        guard let loafjetView = Utils.topMostWindowController()?.view else { return }

        guard loafHeight >= 40, loafHeight <= 90, loafWidth >= 240 else {
            print("Pod Loafjet: Plain Loaf must have Height varying from 90 - 40 and Width greater than 240")
            return
        }

        /// Label & Image size calculation according to the parameters added
        let metrics = getImageDynamics(height: loafHeight, imageName: loafImage)

        // LOAF VIEW METHOD
        plainLoafView.frame = position.centerPoint(view: loafjetView, width: loafWidth, height: loafHeight)
        plainLoafView.backgroundColor = bgColor.withAlphaComponent(alphaValue)
        plainLoafView.layer.cornerRadius = cornerRadius
        plainLoafView.clipsToBounds = true

        // LOAF LABEL METHOD
        let labelWidth = (loafWidth / 2 - (metrics.labelSpace)) * 2
        plainLoafLabel.frame = CGRect(x: metrics.labelSpace, y: 0, width: labelWidth, height: loafHeight)
        plainLoafLabel.textAlignment = .center
        plainLoafLabel.text = message
        plainLoafLabel.font = UIFont(name: fontStyle, size: fontSize)
        plainLoafLabel.textColor = fontColor
        plainLoafLabel.numberOfLines = 3
        plainLoafLabel.adjustsFontSizeToFitWidth = true

        // LOAF IMAGE METHOD

        plainLoafImageView.frame = CGRect(x: 15, y: loafHeight / 2 - metrics.imageLength / 2, width: metrics.imageLength, height: metrics.imageLength)
        plainLoafImageView.contentMode = .scaleAspectFit
        if loafImage.trimmingCharacters(in: .whitespaces) != "" {
            plainLoafImageView.isHidden = false
            plainLoafImageView.image = UIImage(named: loafImage)
        } else {
            plainLoafImageView.isHidden = true
        }

        // Animation method call
        Animation(Direction: animationDirection, View: loafjetView, DelayTime: duration, LoafLabel: plainLoafLabel, LoafView: plainLoafView, LoafImageView: plainLoafImageView, offset: offset)

        // ADDING LOAF VIEW TO THE PRESENTATION VIEW
        plainLoafView.addSubview(plainLoafLabel)
        plainLoafView.addSubview(plainLoafImageView)
        loafjetView.addSubview(plainLoafView)
        loafjetView.bringSubviewToFront(plainLoafView)
    }

    // MARK: - Gradient Loaf Method

    /// Gradient Loafs a Loaf view with different types of gradient background and various position placement support.
    /// - Parameters:
    ///   - message: Message to show on Loaf
    ///   - position: Where to place the Loaf
    ///   - loafWidth: Width of Loaf
    ///   - loafHeight: Height of Loaf
    ///   - cornerRadius: CornerRadius of Loaf
    ///   - fontStyle: Font style of Loaf
    ///   - fontSize: Font size of Loaf
    ///   - bgColor1: Gradient color 1
    ///   - bgColor2: Gradient color 2
    ///   - fontColor: Font colour of Loaf
    ///   - loafImage: Image to show on Loaf
    ///   - animationDirection: Loaf Animation Direction
    ///   - duration: Animation Duration
    ///   - loafjetView: UIView on which the Loaf is to be presented

    public static func gradientLoaf(message: String, position: LoafPosition, loafWidth: CGFloat = 240, loafHeight: CGFloat = 40, cornerRadius: CGFloat = 20, fontStyle: String = "Avenir-Medium", fontSize: CGFloat = 17, bgColor1: UIColor, bgColor2: UIColor, fontColor: UIColor, loafImage: String = "", animationDirection: LoafAnimation, duration: TimeInterval = 2.0, loafjetView: UIView) {
        guard loafHeight >= 40, loafHeight <= 90, loafWidth >= 240 else {
            print("Pod Loafjet: Gradient Loaf must have Height varying from 90 - 40 and Width greater than 240")
            return
        }

        /// Label & Image size calculation according to the parameters added
        let metrics = getImageDynamics(height: loafHeight, imageName: loafImage)

        /// To remove previously added gradient layer
        gradientLoafView.layer.sublayers?.remove(at: 0)

        // LOAF VIEW METHOD
        gradientLoafView.frame = position.centerPoint(view: loafjetView, width: loafWidth, height: loafHeight)
        gradientLoafView.layer.cornerRadius = cornerRadius
        gradientLoafView.clipsToBounds = true

        // LOAF LABEL METHOD
        let labelWidth = (loafWidth / 2 - (metrics.labelSpace)) * 2
        gradientLoafLabel.frame = CGRect(x: metrics.labelSpace, y: 0, width: labelWidth, height: loafHeight)
        gradientLoafLabel.textAlignment = .center
        gradientLoafLabel.text = message
        gradientLoafLabel.font = UIFont(name: fontStyle, size: fontSize)
        gradientLoafLabel.textColor = fontColor
        gradientLoafLabel.adjustsFontSizeToFitWidth = true

        // GRADIENT BG METHOD
        let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [bgColor1.cgColor, bgColor2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.cornerRadius = cornerRadius
            gradientLoafView.layer.insertSublayer(gradientLayer, at: 0)
            gradientLoafView.clipsToBounds = true
            gradientLoafView.backgroundColor = .none
            return gradientLayer
        }()
        gradientLayer.frame = gradientLoafView.bounds

        // LOAF IMAGE METHOD
        gradientLoafImageView.frame = CGRect(x: 15, y: loafHeight / 2 - metrics.imageLength / 2, width: metrics.imageLength, height: metrics.imageLength)
        gradientLoafView.contentMode = .scaleAspectFit
        if loafImage.trimmingCharacters(in: .whitespaces) != "" {
            gradientLoafImageView.isHidden = false
            gradientLoafImageView.image = UIImage(named: loafImage)
        } else {
            gradientLoafImageView.isHidden = true
        }

        // Animation method call
        Animation(Direction: animationDirection, View: loafjetView, DelayTime: duration, LoafLabel: gradientLoafLabel, LoafView: gradientLoafView, LoafImageView: gradientLoafImageView)

        // ADDING LOAF VIEW TO THE PRESENTATION VIEW
        gradientLoafView.addSubview(gradientLoafLabel)
        gradientLoafView.addSubview(gradientLoafImageView)

        // ADDING LOAF TO THE VIEW
        loafjetView.addSubview(gradientLoafView)
    }
}

// MARK: - Popup Card Method

public extension AIToastTest {
    /// PopupCard is a card animation used to display quick info on screen.
    /// - Parameters:
    ///   - message: Message to show on Card
    ///   - loafWidth: Width of Card
    ///   - loafHeight: Height of Card
    ///   - cornerRadius: CornerRadius of Card
    ///   - fontStyle: Font style of Card
    ///   - fontSize: Font size of Card
    ///   - bgColor1: Gradient color 1
    ///   - bgColor2: Gradient color 2
    ///   - fontColor: Font colour of Card
    ///   - loafImage: Image to show on Card
    ///   - duration: Animation Duration
    ///   - loafjetView: UIView on which the Card is to be presented

    static func popupCard(message: String, loafWidth: CGFloat = 150, loafHeight: CGFloat = 40, cornerRadius: CGFloat = 20, fontStyle: String = "Avenir-Medium", fontSize: CGFloat = 17, bgColor1: UIColor, bgColor2: UIColor, fontColor: UIColor, loafImage: String, duration: TimeInterval = 2.0, blurEffect: UIBlurEffect.Style?, loafjetView: UIView) {
        guard loafHeight >= 300, loafWidth >= 250 else {
            print("Pod Loafjet: Popup card must have Height greater than 300 and Width greater than 250")
            return
        }

        popUpCardView.layer.sublayers?.remove(at: 0) // To remove previously added gradient layer

        // LOAF VIEW METHOD
        popUpCardView.frame = CGRect(x: loafjetView.center.x, y: loafjetView.center.y, width: loafWidth, height: loafHeight)
        popUpCardView.layer.cornerRadius = cornerRadius
        popUpCardView.clipsToBounds = true

        // LOAF LABEL METHOD
        let estimatedLabelHeight = loafHeight - 150 // Space left after addition of Image
        popUpCardLabel.frame = CGRect(x: loafWidth / 2 - ((loafWidth - 8) / 2), y: 140, width: loafWidth - 8, height: estimatedLabelHeight)
        popUpCardLabel.text = message
        popUpCardLabel.font = UIFont(name: fontStyle, size: fontSize)
        popUpCardLabel.textColor = fontColor
        popUpCardLabel.numberOfLines = .max
        popUpCardLabel.textAlignment = .center

        // GRADIENT BG METHOD
        let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [bgColor1.cgColor, bgColor2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.cornerRadius = cornerRadius
            popUpCardView.layer.insertSublayer(gradientLayer, at: 0)
            popUpCardView.clipsToBounds = true
            popUpCardView.backgroundColor = .none
            return gradientLayer
        }()
        gradientLayer.frame = popUpCardView.bounds

        // POPUP CARD IMAGE METHOD
        popUpCardImageView.frame = CGRect(x: loafWidth / 2 - 50, y: 20, width: 100, height: 100)
        popUpCardImageView.image = UIImage(named: loafImage)

        // Blur Effect call
        applyBlurEffect(effect: blurEffect, view: loafjetView)

        // Pinning elements to POPUP View
        popUpCardView.addSubview(popUpCardLabel)
        popUpCardView.addSubview(popUpCardImageView)

        // Pinning POPUP View to main view
        loafjetView.addSubview(popUpCardView)

        // Animation method call

        popUpCardView.center.x = loafjetView.center.x
        popUpCardView.center.y = loafjetView.center.y + 4000

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            // For bottom to top
            popUpCardView.center.x = loafjetView.center.x
            popUpCardView.center.y = loafjetView.center.y + 45
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut) {
                // top to bottom direction
                popUpCardView.center.y = loafjetView.center.y + 800
                // for dismissal of blur effect
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    visualEffect.removeFromSuperview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        popUpCardView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

// MARK: - Loader Loaf Method

public extension AIToastTest {
    /// LoafWheel is a custom loader view with gradient background support
    /// - Parameters:
    ///   - message: Message to show on Loaf
    ///   - loafWidth: Width of Loaf
    ///   - loafHeight: Height of Loaf
    ///   - cornerRadius: CornerRadius of Loaf
    ///   - bgColor1: Gradient color 1
    ///   - bgColor2: Gradient color 2
    ///   - fontStyle: Font style of Loaf
    ///   - fontSize: Font size of Loaf
    ///   - fontColor: Font colour of Loaf
    ///   - duration: Animation Duration
    ///   - wheelStyle: Activity Indicator type
    ///   - blurEffect: Blur Effect type
    ///   - loafjetView: UIView on which the Loaf is to be presented

    static func loafWheel(message: String, loafWidth: CGFloat = 50, loafHeight: CGFloat = 50, cornerRadius: CGFloat = 20, bgColor1: UIColor, bgColor2: UIColor, fontStyle: String = "Avenir-Medium", fontSize: CGFloat = 17, fontColor: UIColor = .black, duration: TimeInterval = 2.0, wheelStyle _: UIActivityIndicatorView.Style = .white, blurEffect: UIBlurEffect.Style? = .regular, loafWheelView: UIView) {
        guard loafHeight >= 100, loafWidth >= 100 else {
            print("Pod Loafjet: Loaf Wheel must have Height and Width greater than 100")
            return
        }

        loafWheelView.layer.sublayers?.remove(at: 0) // To remove previously added gradient layer

        // LOAF VIEW METHOD
        loafWheelView.frame = CGRect(x: loafWheelView.center.x, y: loafWheelView.center.y, width: loafWidth, height: loafHeight)
        loafWheelView.layer.cornerRadius = cornerRadius
        loafWheelView.clipsToBounds = true
        loafWheelView.center.x = loafWheelView.center.x
        loafWheelView.center.y = loafWheelView.center.y

        // GRADIENT BG METHOD
        let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [bgColor1.cgColor, bgColor2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.cornerRadius = cornerRadius
            loafWheelView.layer.insertSublayer(gradientLayer, at: 0)
            loafWheelView.clipsToBounds = true
            loafWheelView.backgroundColor = .none
            return gradientLayer
        }()
        gradientLayer.frame = loafWheelView.bounds

        // LOAF LABEL METHOD
        loafWheelLabel.frame = CGRect(x: 0, y: 0, width: loafWidth, height: loafHeight)
        loafWheelLabel.textAlignment = .center
        loafWheelLabel.numberOfLines = .max
        loafWheelLabel.text = message
        loafWheelLabel.font = UIFont(name: fontStyle, size: fontSize)
        loafWheelLabel.textColor = fontColor

        // Adding Indicator
        wheel.frame = CGRect(x: loafWheelView.frame.origin.x + loafWidth / 2 - 25, y: loafHeight - 50, width: 50, height: 50)
        wheel.hidesWhenStopped = true
        wheel.startAnimating()

        // Apply Blur effect call
        applyBlurEffect(effect: blurEffect, view: loafWheelView)
        loafWheelView.addSubview(loafWheelLabel)
        loafWheelView.addSubview(wheel)
        loafWheelView.addSubview(loafWheelView)
        loafWheelView.isUserInteractionEnabled = false

        // for dismissal of blur effect
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.4) {
            loafWheelLabel.removeFromSuperview()
            loafWheelView.removeFromSuperview()
            wheel.removeFromSuperview()
            visualEffect.removeFromSuperview()
            loafWheelView.isUserInteractionEnabled = true
        }
    }

    // MARK: - Loader Dismissal Method

    static func dismissWheel(loafWheelView: UIView) {
        loafWheelLabel.removeFromSuperview()
        loafWheelView.removeFromSuperview()
        wheel.removeFromSuperview()
        visualEffect.removeFromSuperview()
        loafWheelView.isUserInteractionEnabled = true
    }
}

// MARK: - Dash Board Methods

public extension AIToastTest {
    /// Dash board is an user interactive Loaf with image, title , content and button support.
    /// - Parameters:
    ///   - dashSpacing: space to be left on both the sides of dashBoard
    ///   - dashRadius: cornerRadius of dashBoard
    ///   - dashColor: dashBoard background colour
    ///   - dashImage: image used in dashBoard
    ///   - dashImageRadius: cornerRadius of dash image
    ///   - dashTitle: main title of dashBoard
    ///   - dashTitleColor: dashBoard Title colour
    ///   - dashContent: content text on dashBoard
    ///   - dashContentColor: content text colour
    ///   - dashButtonTitle: dashBoard button title text
    ///   - dashButtonTitleColor: dashBoard button title colour
    ///   - dashButtonColor: dashBoard button background colour
    ///   - dashButtonRadius: dashBoard button cornerRadius
    ///   - dashButtonBorderColor: dashBoard button border colour
    ///   - dashButtonBorderWidth: dashBoard button border width
    ///   - dashDuration: duration of dashBoard presentation
    ///   - mainView: view in which dashBoard is to be presented
    ///   - completion: completion handler to add button action

    @available(iOS 14.0, *)
    static func dashBoard(dashSpacing: CGFloat = 40, dashRadius: CGFloat = 20, dashColor: UIColor = .white, dashImage: String, dashImageRadius: CGFloat = 20, dashTitle: String, dashTitleColor: UIColor = .black, dashContent: String, dashContentColor: UIColor = .black, dashButtonTitle: String, dashButtonTitleColor: UIColor = .black, dashButtonColor: UIColor = .white, dashButtonRadius: CGFloat = 20, dashButtonBorderColor: UIColor = .white, dashButtonBorderWidth: CGFloat = 2, dashDuration: TimeInterval = 0.75, mainView: UIView, completion: @escaping () -> Void) {
        dashView.layer.sublayers = nil // Important: to remove the previously added layer

        // Dash View Elements
        let contentLabel = UILabel()
        let titleLabel = UILabel()
        let dashPic = UIImageView()
        let dashButton = UIButton()

        dashSpacingCopy = dashSpacing // assigning value to dashPassOns

        // Main Card Setup
        dashView.frame = CGRect(x: dashSpacing, y: (mainView.frame.height / 3) * 2 + 1000, width: mainView.frame.width - (2 * dashSpacing), height: mainView.frame.height / 3 + 10)
        dashView.backgroundColor = dashColor
        dashView.layer.cornerRadius = dashRadius
        dashView.clipsToBounds = true

        // ImageView Setup
        let imageSize = dashView.frame.height / 3
        dashPic.frame = CGRect(x: dashView.frame.width / 2 - imageSize / 2, y: dashView.frame.height / 4 - imageSize / 2 - 10, width: imageSize, height: imageSize)
        dashPic.image = UIImage(named: dashImage)
        dashPic.backgroundColor = UIColor.clear
        dashPic.layer.cornerRadius = dashImageRadius

        // Title Label Setup
        titleLabel.frame = CGRect(x: 10, y: imageSize + 20, width: dashView.frame.width - 20, height: 30)
        titleLabel.text = dashTitle
        titleLabel.font = UIFont(name: "Avenir Heavy", size: 24)
        titleLabel.textColor = dashTitleColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.clipsToBounds = true
        titleLabel.backgroundColor = UIColor.clear

        // Content Label Setup
        contentLabel.frame = CGRect(x: 10, y: imageSize + 50, width: dashView.frame.width - 20, height: dashView.frame.height / 4)
        contentLabel.text = dashContent
        contentLabel.textColor = dashContentColor
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont(name: "Avenir Regular", size: 19)
        contentLabel.backgroundColor = UIColor.clear
        contentLabel.textAlignment = .center
        contentLabel.clipsToBounds = true
        contentLabel.layer.cornerRadius = 20

        // Button Setup
        dashButton.frame = CGRect(x: 10, y: dashView.bounds.height - dashView.frame.height / 6 - 5, width: dashView.frame.width - 20, height: dashView.frame.height / 6)
        dashButton.setTitle(dashButtonTitle, for: .normal)
        dashButton.backgroundColor = dashButtonColor
        dashButton.setTitleColor(dashButtonTitleColor, for: .normal)
        dashButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        dashButton.layer.cornerRadius = dashButtonRadius
        dashButton.layer.borderWidth = dashButtonBorderWidth
        dashButton.layer.borderColor = dashButtonBorderColor.cgColor
        dashButton.clipsToBounds = true

        // DashBoard button action
        dashButton.addAction(UIAction(handler: { _ in
            completion()
        }), for: .touchUpInside)

        // animation method
        UIView.animate(withDuration: dashDuration, delay: 0, options: .curveEaseOut) {
            // For bottom to top
            self.dashView.frame = CGRect(x: dashSpacing, y: (mainView.frame.height / 3) * 2 - 30, width: mainView.frame.width - (2 * dashSpacing), height: mainView.frame.height / 3 + 10)
        }

        // Adding Views
        dashView.addSubview(titleLabel)
        dashView.addSubview(dashPic)
        dashView.addSubview(dashButton)
        dashView.addSubview(contentLabel)
        mainView.addSubview(dashView)
    }

    // Dash board dismissal function
    static func dismissDashBoard(dashBoardView: UIView) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut) {
            AIToastTest.dashView.frame = CGRect(x: dashSpacingCopy, y: (dashBoardView.frame.height / 3) * 2 + 1000, width: dashBoardView.frame.width - 20, height: dashBoardView.frame.height / 3)
        }
    }
}
