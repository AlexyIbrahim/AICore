//
// Created by Alexy Ibrahim on 10/23/22.
//

import Foundation
import UIKit

extension Notification.Name {
    static let INJECTION_BUNDLE_NOTIFICATION = Notification.Name(rawValue: "INJECTION_BUNDLE_NOTIFICATION")
    static let USER_DID_TAKE_SCREENSHOT_NOTIFICATION = UIApplication.userDidTakeScreenshotNotification
    static let CAPTURED_DID_CHANGE_NOTIFICATION = UIScreen.capturedDidChangeNotification
}

public class AIHotline {
    static let shared = AIHotline()

    public static var keyboardHeight: CGFloat?
    public var keyboardWillShowCallBack: (() -> Void)?
    public var keyboardWillHideCallBack: (() -> Void)?
    public var keyboardDidShowCallBack: (() -> Void)?
    public var keyboardDidHideCallBack: (() -> Void)?
    public var userDidTakeScreenshot: (() -> Void)?
    public var captureDidChange: ((_ isCaptured: Bool) -> Void)?

    public init() {
        self.registerNotifications()
    }

    private func registerNotifications() {
        registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidDisappear(_:)), name: .USER_DID_TAKE_SCREENSHOT_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidDisappear(_:)), name: .CAPTURED_DID_CHANGE_NOTIFICATION, object: nil)
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    deinit {
        deregisterNotifications()
    }

    func deregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .USER_DID_TAKE_SCREENSHOT_NOTIFICATION, object: nil)
        NotificationCenter.default.removeObserver(self, name: .CAPTURED_DID_CHANGE_NOTIFICATION, object: nil)
    }

    public final class func notifyListeners(notificationName: Notification.Name, object: Any? = nil) {
        postNotification(notificationName, object: object)
    }
    
    public final class func postNotification(_ notificationName: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: notificationName, object: object)

//        @objc func methodOfReceivedNotification(notification: Notification) {
//            // Take Action on Notification
//            self.fetchFreeIntroNotification(showProgress: false)
//        }
    }
    
    public final class func addNotificationObserverFor(_ notificationName: Notification.Name, object: Any? = nil, _ closure: @escaping (Notification)->()) -> Any {
        class ClosureSleeve: NSObject {
            let closure: (Notification) -> Void
            init(_ closure: @escaping (Notification) -> Void) {
                self.closure = closure
            }
            @objc func invoke(notification: Notification) {
                closure(notification)
            }
        }
        let sleeve = ClosureSleeve(closure)
        
        NotificationCenter.default.addObserver(sleeve, selector: #selector(ClosureSleeve.invoke(notification:)), name: notificationName, object: object)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return sleeve
    }
    
    public final class func addNotificationObserverFor(_ notificationName: Notification.Name, _ closure: @escaping ()->()) -> Any {
        return addNotificationObserverFor(notificationName) { notification in
            closure()
        }
    }
    
    public final class func addNotificationObserverFor(_ notificationName: Notification.Name, actionTarget: Any, action: Selector) {
        NotificationCenter.default.addObserver(actionTarget, selector: action, name: notificationName, object: nil)
    }
    
    public final class  func removeNotificationObserverFrom(actionTarget: Any, notificationName: Notification.Name) {
        NotificationCenter.default.removeObserver(actionTarget, name: notificationName, object: nil)
    }
    
}

// manually implemented notifications
extension AIHotline {
    // keyboard
    @objc private func onKeyboardWillAppear(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            AIHotline.keyboardHeight = keyboardHeight
            self.keyboardWillShowCallBack?()
        }
    }

    @objc private func onKeyboardWillDisappear(_ notification: NSNotification) {
        self.keyboardWillHideCallBack?()
    }

    @objc private func onKeyboardDidAppear(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            AIHotline.keyboardHeight = keyboardHeight
            self.keyboardDidShowCallBack?()
        }
    }

    @objc private func onKeyboardDidDisappear(_ notification: NSNotification) {
        self.keyboardDidHideCallBack?()
    }
    
    // screenshot
    @objc private func userDidTakeScreenshot(_ notification: NSNotification) {
        self.userDidTakeScreenshot?()
    }
    
    // screen recording
    @objc private func screenCaptureDidChange(_ notification: NSNotification) {
        if UIScreen.main.isCaptured {
            self.captureDidChange?(true)
        } else {
            self.captureDidChange?(false)
        }
    }
}
