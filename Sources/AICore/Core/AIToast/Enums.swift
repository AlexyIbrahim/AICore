
import Foundation
import UIKit

// MARK: - Enumeration Keys

public extension AIToastTest {
    // MARK: - Position Method

    enum LoafPosition {
        case top
        case center
        case bottom

        func centerPoint(view: UIView, width: CGFloat, height: CGFloat) -> CGRect {
            switch self {
            case .top:
                return CGRect(x: view.frame.origin.x, y: view.frame.origin.y - height, width: width, height: height)
            case .center:
                return CGRect(x: view.frame.origin.x, y: view.center.y - height / 2, width: width, height: height)
            case .bottom:
                return CGRect(x: view.frame.origin.x, y: view.bounds.height + height, width: width, height: height)
            }
        }
    }

    // MARK: - Toast Animation Method

    enum LoafAnimation {
        case left
        case right
        case bottom
        case top
    }
}
