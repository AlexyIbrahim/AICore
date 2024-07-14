//
//  UIViewExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import SnapKit
import UIKit

public extension UIView {
    func makeCircular() {
        layer.cornerRadius = bounds.height / 2
    }

    func makeRounded(cornerRadius: CGFloat? = nil) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius ?? 8
    }

	func setCornerRadii(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
		let path = UIBezierPath()
		let bounds = self.bounds
		
		// Start from the top left corner
		path.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))
		
		// Top edge to the top right corner
		path.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
		path.addArc(withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight), radius: topRight, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
		
		// Right edge to the bottom right corner
		path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
		path.addArc(withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight), radius: bottomRight, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
		
		// Bottom edge to the bottom left corner
		path.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
		path.addArc(withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft), radius: bottomLeft, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
		
		// Left edge back to the top left corner
		path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
		path.addArc(withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft), radius: topLeft, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
		
		// Close the path
		path.close()
		
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
    var isAnimating: Bool {
        return (layer.animationKeys()?.count ?? 0) > 0
    }

    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func safelyRemoveFromSuperview() {
        if superview != nil {
            removeFromSuperview()
        }
    }

    func addShadow(color: UIColor? = nil, opacity: Float? = nil, offset: CGSize? = nil, radius: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 0.5
        layer.shadowOffset = offset ?? CGSize(width: 2, height: 2)
        layer.shadowRadius = radius ?? 4
    }

    func addRing(withColor color: UIColor, thickness: CGFloat, padding: CGFloat, masksToBounds: Bool? = nil) -> CAShapeLayer {
        let ringLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: bounds.insetBy(dx: padding, dy: padding))

        ringLayer.path = circlePath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = color.cgColor
        ringLayer.lineWidth = thickness
        if let masksToBounds = masksToBounds {
            ringLayer.masksToBounds = masksToBounds
        }

        layer.addSublayer(ringLayer)

        return ringLayer
    }
	
	var isVisible: Bool {
		var result = false
		let semaphore = DispatchSemaphore(value: 0)
		
		mainThread(isSynchronous: true) { [weak self] in
			guard let self = self else { return }
			
			defer { semaphore.signal() }
			
			if self.isHidden {
				result = false
				return
			}
			
			if self.window == nil {
				result = false
				return
			}
			
			if self.alpha <= 0 {
				result = false
				return
			}
			
			if self.superview == nil {
				result = false
				return
			}
			
			if self.superview?.frame.intersects(self.frame) == false {
				result = false
				return
			}
			
			result = true
		}
		
		semaphore.wait()
		return result
	}
	
	var zPosition: CGFloat {
		get {
			self.layer.zPosition
		}
		set {
			self.layer.zPosition = newValue
		}
	}
	
	func bringToFront() {
		self.superview?.bringSubviewToFront(self)
	}
	
	func sendToBack() {
		self.superview?.sendSubviewToBack(self)
	}
}

// constaint

public extension UIView {
    func hasConstraints() -> Bool {
        return !constraints.isEmpty
    }

    func hasConstraint(_ constraint: NSLayoutConstraint.Attribute) -> Bool {
        let constraintAttributes = constraints
        return constraintAttributes.contains(where: { item -> Bool in
            item.firstAttribute.rawValue == constraint.rawValue
        })
    }

    func getConstraint(_ constraint: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let constraintAttributes = constraints
        return constraintAttributes.first {
            $0.firstAttribute.rawValue == constraint.rawValue
        }
    }

    func hasSuperview() -> Bool {
        if superview != nil {
            return true
        }
        return false
    }

    func hide(animated: Bool? = nil, duration: TimeInterval? = nil) {
        if animated ?? false {
            UIView.animate(withDuration: duration ?? 0.3, delay: .zero) {
                self.alpha = 0
            } completion: { completed in
                if completed {
                    self.isHidden = true
                }
            }
        } else {
            isHidden = true
        }
    }

    func unhide(animated: Bool? = nil) {
        show(animated: animated)
    }

    func show(animated: Bool? = nil, duration: TimeInterval? = nil) {
        if animated ?? false {
            alpha = 0
            isHidden = false
            UIView.animate(withDuration: duration ?? 0.3, delay: .zero) {
                self.alpha = 1
            } completion: { _ in
            }
        } else {
            isHidden = false
        }
    }

    func applyBoxConstraints(top: CGFloat, horizontalMargin: CGFloat? = nil, height: CGFloat? = nil, topRelativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { make in
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
        if hasConstraints() {
            snp.updateConstraints(closure)
        } else {
            snp.makeConstraints(closure)
        }
    }

    func applyLeadingTrailingMargin(_ v: CGFloat) {
        let closure: (_ make: ConstraintMaker) -> Void = { make in
            make.leading.equalToSuperview().offset(v)
            make.trailing.equalToSuperview().offset(-v)
        }
        if hasConstraints() {
            snp.updateConstraints(closure)
        } else {
            snp.makeConstraints(closure)
        }
    }

    func centerHorizontally(relativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { make in
            if let relativeView = relativeView {
                make.centerX.equalTo(relativeView)
            } else {
                make.centerX.equalToSuperview()
            }
        }
        if hasConstraints() {
            snp.updateConstraints(closure)
        } else {
            snp.makeConstraints(closure)
        }
    }

    func centerVertically(relativeView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { make in
            if let relativeView = relativeView {
                make.centerY.equalTo(relativeView)
            } else {
                make.centerY.equalToSuperview()
            }
        }
        if hasConstraints() {
            snp.updateConstraints(closure)
        } else {
            snp.makeConstraints(closure)
        }
    }

    func applyTopMargin(_ v: CGFloat, relView: UIView? = nil) {
        let closure: (_ make: ConstraintMaker) -> Void = { make in
            if let view = relView {
                make.top.equalTo(view).offset(v)
            } else {
                make.top.equalToSuperview().offset(v)
            }
        }
        if hasConstraints() {
            snp.updateConstraints(closure)
        } else {
            snp.makeConstraints(closure)
        }
    }
}

// gestures
public extension UIView {
    func onTap(_ closure: @escaping () -> Void) {
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
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    func onLongTap(_ closure: @escaping (_ gestureReconizer: UILongPressGestureRecognizer) -> Void) {
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
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    func removeAllGestureRecognizers() {
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
}

// subviews
public extension UIView {
    /// Add multiple Auto Layout subviews at the same time.
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    func add(views: [UIView]) {
        addSubviews(views: views)
    }

    private func addSubviews(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
	
	func removeAllSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
	
	func hasSubviewWithTag(_ tag: Int) -> Bool {
		for subview in subviews {
			if subview.tag == tag {
				return true
			}
			if subview.hasSubviewWithTag(tag) {
				return true
			}
		}
		return false
	}
}
