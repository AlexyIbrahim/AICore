//
//  UIViewExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import UIKit
import SnapKit


public extension UIView {
    func makeCircular() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    var isAnimating: Bool {
        return (self.layer.animationKeys()?.count ?? 0) > 0
    }
    
    func removeSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

// constaint

public extension UIView {
    func hasConstraints() -> Bool {
        return !self.constraints.isEmpty
    }
    
    func hasConstraint(_ constraint: NSLayoutConstraint.Attribute) -> Bool {
        let constraintAttributes = self.constraints
        return constraintAttributes.contains(where: { (item) -> Bool in
            return item.firstAttribute.rawValue == constraint.rawValue
        })
    }
    
    func getConstraint(_ constraint: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let constraintAttributes = self.constraints
        return constraintAttributes.first {
            $0.firstAttribute.rawValue == constraint.rawValue
        }
    }
    
    func hasSuperview() -> Bool {
        if self.superview != nil {
            return true
        }
        return false
    }
    
    func applyBoxConstraints(top: CGFloat, horizontalMargin: CGFloat? = nil, height: CGFloat? = nil, topRelativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { (make) -> Void in
            if let topRelativeView = topRelativeView {
                make.top.equalTo(topRelativeView.snp.bottom).offset(top)
            } else {
                make.top.equalToSuperview().offset(top)
            }
            if let horizontalMargin = horizontalMargin {
                make.leading.equalToSuperview().offset(horizontalMargin)
                make.trailing.equalToSuperview().offset(-horizontalMargin)
            }
            if let height = height {
                make.height.equalTo(height)
            }
        }
        if self.hasConstraints() {
            self.snp.updateConstraints(closure)
        } else {
            self.snp.makeConstraints(closure)
        }
    }
    
    func applyLeadingTrailingMargin(_ v: CGFloat) {
        let closure: (_ make: ConstraintMaker) -> Void = { (make) -> Void in
            make.leading.equalToSuperview().offset(v)
            make.trailing.equalToSuperview().offset(-v)
        }
        if self.hasConstraints() {
            self.snp.updateConstraints(closure)
        } else {
            self.snp.makeConstraints(closure)
        }
    }
    
    func centerHorizontally(relativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { (make) -> Void in
            if let relativeView = relativeView {
                make.centerX.equalTo(relativeView)
            } else {
                make.centerX.equalToSuperview()
            }
        }
        if self.hasConstraints() {
            self.snp.updateConstraints(closure)
        } else {
            self.snp.makeConstraints(closure)
        }
    }
    
    func centerVertically(relativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { (make) -> Void in
            if let relativeView = relativeView {
                make.centerY.equalTo(relativeView)
            } else {
                make.centerY.equalToSuperview()
            }
        }
        if self.hasConstraints() {
            self.snp.updateConstraints(closure)
        } else {
            self.snp.makeConstraints(closure)
        }
    }
    
    func applyTopMargin(_ v: CGFloat, relView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { (make) -> Void in
            if let view = relView {
                make.top.equalTo(view).offset(v)
            } else {
                make.top.equalToSuperview().offset(v)
            }
        }
        if self.hasConstraints() {
            self.snp.updateConstraints(closure)
        } else {
            self.snp.makeConstraints(closure)
        }
    }
}

// gestures
public extension UIView {
    func onTap(_ closure: @escaping ()->()) {
        class ClosureSleeve: NSObject {
            let closure: () -> Void
            init(_ closure: @escaping () -> Void) {
                self.closure = closure
            }
            @objc func invoke() {
                closure()
            }
        }
        let sleeve = ClosureSleeve(closure)
        //            addTarget(sleeve, action: Selector(("invoke")), for: controlEvents)
        
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        self.addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func onLongTap(_ closure: @escaping (_ gestureReconizer: UILongPressGestureRecognizer)->()) {
        class ClosureSleeve: NSObject {
            let closure: (_ gestureReconizer: UILongPressGestureRecognizer) -> Void
            init(_ closure: @escaping (_ gestureReconizer: UILongPressGestureRecognizer) -> Void) {
                self.closure = closure
            }
            @objc func invoke(gestureReconizer: UILongPressGestureRecognizer) {
                closure(gestureReconizer)
            }
        }
        let sleeve = ClosureSleeve(closure)
        
        isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke(gestureReconizer:)))
        gesture.minimumPressDuration = 0.5
        gesture.delaysTouchesBegan = true
        self.addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func removeAllGestureRecognizers() {
        if let gestureRecognizers = self.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
}
