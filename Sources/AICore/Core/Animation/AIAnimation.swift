//
//  AIAnimation.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import Foundation
import UIKit

public class AIAnimation {
    public final class func pulsate(view: UIView) {
//        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scaleAnimation.duration = 1.0
//        scaleAnimation.repeatCount = 3.0
//        scaleAnimation.autoreverses = true
//        scaleAnimation.fromValue = 1.0;
//        scaleAnimation.toValue = 1.2;
//        view.layer.add(scaleAnimation, forKey: "scale")

        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
            view.transform = CGAffineTransformMakeScale(1.2, 1.2)
        } completion: { _ in
        }
    }

    public final class func endPulsate(for view: UIView) {
        UIView.animateKeyframes(withDuration: 0.01, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            view.transform = CGAffineTransformIdentity
        } completion: { _ in
        }
    }

    public final class func removeAnimations(for view: UIView) {
        view.layer.removeAllAnimations()
    }

    public final class func isAnimating(_ view: UIView) -> Bool {
        view.isAnimating
    }
}
