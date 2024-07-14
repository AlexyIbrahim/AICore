//
//  UIControlExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/25/22.
//

import Foundation
import UIKit

public extension UIControl {
	func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
		addAction(for: controlEvents) { control in
			closure()
		}
	}
	
	func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping (UIControl)->()) {
		// Remove previously set actions for the specified control events
		removeActions(for: controlEvents)
		
		if #available(iOS 14.0, *) {
			addAction(UIAction { (action: UIAction) in closure(self) }, for: controlEvents)
		} else {
			class ClosureSleeve: NSObject {
				let closure: (UIControl) -> Void
				weak var control: UIControl?
				
				init(_ closure: @escaping (UIControl) -> Void, control: UIControl?) {
					self.closure = closure
					self.control = control
				}
				
				@objc func invoke() {
					if let control = self.control {
						closure(control)
					}
				}
			}
			
			let sleeve = ClosureSleeve(closure, control: self)
			addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
			objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	func removeActions(for event: UIControl.Event) {
		removeTarget(nil, action: nil, for: event)
	}
	
	func removeAllActions() {
		removeTarget(nil, action: nil, for: .allEvents)
	}
}

internal let ClosureHandlerSelector = Selector(("handle"))

internal class ClosureHandler<T: AnyObject>: NSObject {
	
	internal var handler: ((T) -> Void)?
	internal weak var control: T?
	
	internal init(handler: @escaping (T) -> Void, control: T? = nil) {
		self.handler = handler
		self.control = control
	}
	
	@objc func handle() {
		if let control = self.control {
			handler?(control)
		}
	}
}


public extension UIControl {
	
	/// Adds a handler that will be invoked for the specified control events
	func on(_ controlEvents: UIControl.Event, invokeHandler handler: @escaping (UIControl) -> Void) -> AnyObject {
		let closureHandler = ClosureHandler(handler: handler, control: self)
		addTarget(closureHandler, action: ClosureHandlerSelector, for: controlEvents)
		handlers.insert(closureHandler)
		return closureHandler
	}
	
	/// Removes a handler from the control
	func removeHandler(_ handler: AnyObject) {
		guard let handler = handler as? ClosureHandler<UIControl> else { return }
		removeTarget(handler, action: ClosureHandlerSelector, for: .allEvents)
		handlers.remove(handler)
	}
}

private var HandlerKey: UInt8 = 0

private extension UIControl {
	
	var handlers: Set<ClosureHandler<UIControl>> {
		get { return (objc_getAssociatedObject(self, &HandlerKey) as? Set<ClosureHandler<UIControl>>) ?? Set<ClosureHandler<UIControl>>() }
		set { objc_setAssociatedObject(self, &HandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
}
