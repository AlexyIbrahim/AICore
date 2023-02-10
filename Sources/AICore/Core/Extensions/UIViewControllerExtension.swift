//
//  UIViewControllerExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/14/22.
//

import Foundation
import UIKit

public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        self.dismissKeyboardOnTouch = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func disableKeyboardDismissOnTouch() {
        self.dismissKeyboardOnTouch = false
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if self.dismissKeyboardOnTouch {
            let tapLocation = sender.location(in: view)
            let button = view.hitTest(tapLocation, with: nil) as? UIButton
            
            if let _ = button {
            } else {
                view.endEditing(true)
            }
        }
    }
}

public extension UIViewController {
    struct Holder {
        static var _dismissKeyboardOnTouch:Bool = false
    }
    private var dismissKeyboardOnTouch:Bool {
        get {
            return Holder._dismissKeyboardOnTouch
        }
        set(newValue) {
            Holder._dismissKeyboardOnTouch = newValue
        }
    }
    
    var isModal: Bool {
        let presentingIsModal = self.presentingViewController != nil
        let presentingIsNavigation = self.navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = self.tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || self.isBeingPresented
    }
    
    func fixNavigationBarColor() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    var viewControllerName: String {
        get {
            String(describing: type(of: self))
        }
    }
    
    // MARK: AddBackButton
    func addBackButton(withTitle title: String = "back", tintColor: UIColor? = nil, _ callback: (() -> ())? = nil) {
        let button_BackIcon = UIButton.init(type: .system)
        if let tintColor = tintColor {
            button_BackIcon.tintColor = tintColor
        }
        button_BackIcon.setImage(nil, for: .normal)
        //        button_BackIcon.setImage(UIImage.init(named: "back_icon"), for: .normal)
        button_BackIcon.sizeToFit()
        button_BackIcon.on(.touchUpInside) { (sender) in
            if let callback = callback {
                callback()
            } else {
                self.endViewController()
                //                if self.isBeingPresented {
                //                    self.dismiss(animated: true, completion: nil)
                //                } else {
                //                    self.navigationController?.popViewController(animated: true)
                //                }
            }
        }
        let barButtonItem_BackIcon = UIBarButtonItem.init(customView: button_BackIcon)
        if let tintColor = tintColor {
            barButtonItem_BackIcon.tintColor = tintColor
        }
        
        let button_BackTitle = UIButton.init(type: .system)
        if let tintColor = tintColor {
            button_BackTitle.tintColor = tintColor
        }
        button_BackTitle.setTitle(title, for: .normal)
        button_BackTitle.sizeToFit()
        button_BackTitle.on(.touchUpInside) { (sender) in
            if let callback = callback {
                callback()
            } else {
                if self.isBeingPresented {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        let barButtonItem_BackTitle = UIBarButtonItem.init(customView: button_BackTitle)
        if let tintColor = tintColor {
            barButtonItem_BackTitle.tintColor = tintColor
        }
        self.navigationItem.setLeftBarButtonItems([barButtonItem_BackIcon, barButtonItem_BackTitle], animated: true)
    }
    
    enum BarButtonItemDirection {
        case left
        case right
    }
    
    // MARK: -
    
    // MARK: AddRightButton
    func addBarButtonItem(withTitle title: String? = nil, image: UIImage? = nil, systemItem: UIBarButtonItem.SystemItem? = nil, direction: BarButtonItemDirection, tintColor: UIColor? = nil, _ callback: (() -> ())? = nil) -> UIBarButtonItem {
        var barButtonItem: UIBarButtonItem?
        if title != nil || image != nil {
            let button = UIButton.init(type: .custom)
            if let title = title {
                button.setTitleColor(tintColor, for: .normal)
                button.setTitle(title, for: .normal)
            } else if let image = image {
                button.tintColor = tintColor
                button.setImage(image, for: .normal)
            }
            button.sizeToFit()
            button.on(.touchUpInside) { (sender) in
                callback?()
            }
            
            barButtonItem = UIBarButtonItem.init(customView: button)
        } else if let systemItem = systemItem {
            barButtonItem = UIBarButtonItem.init(systemItem: systemItem, primaryAction: .init { (v: UIAction) in
                callback?()
            })
        }

        if barButtonItem == nil {
            barButtonItem = UIBarButtonItem.init(title: ".", image: nil, primaryAction: .init { (v: UIAction) in
                callback?()
            }, menu: nil)
        }

        if let barButtonItem = barButtonItem {
            if let tintColor = tintColor {
                barButtonItem.tintColor = tintColor
            }

            var array_BarButtonItems = [UIBarButtonItem]()
            switch direction {
            case .left:
                if let barButtonItems = self.navigationItem.leftBarButtonItems {
                    array_BarButtonItems = barButtonItems
                }
                array_BarButtonItems.append(barButtonItem)
                self.navigationItem.setLeftBarButtonItems(array_BarButtonItems, animated: false)
            case .right:
                if let barButtonItems = self.navigationItem.rightBarButtonItems {
                    array_BarButtonItems = barButtonItems
                }
                array_BarButtonItems.append(barButtonItem)
                self.navigationItem.setRightBarButtonItems(array_BarButtonItems, animated: false)
            }
        }

        return barButtonItem!
    }
    
    public func removeBarButtonItems(direction: BarButtonItemDirection, animated: Bool? = nil) {
        switch direction {
        case .left:
            self.navigationItem.setLeftBarButtonItems(nil, animated: animated ?? true)
        case .right:
            self.navigationItem.setRightBarButtonItems(nil, animated: animated ?? true)
        }
    }
    
    func presentViewControllerFromVisibleViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let navigationController = self as? UINavigationController {
            navigationController.topViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent: viewControllerToPresent, animated: flag, completion: completion)
        } else if let tabBarController = self as? UITabBarController {
            tabBarController.selectedViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent: viewControllerToPresent, animated: flag, completion: completion)
        } else if let presentedViewController = presentedViewController {
            presentedViewController.presentViewControllerFromVisibleViewController(viewControllerToPresent: viewControllerToPresent, animated: flag, completion: completion)
        } else {
            present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    // 🌿 Enable detection of shake motion
    //    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    //        if motion == .motionShake {
    //            AIEnvironmentKit.executeIfDebug { () -> () in
    //                MainCoordinator.showAdminPanel()
    //            }
    //        }
    //    }
}

public extension UIViewController {
    func add(_ child: UIViewController, inView subView: UIView? = nil, frame: CGRect? = nil) {
        self.addChild(child)
        
        var contentView:UIView! = self.view
        if let subView = subView {
            contentView = subView
        }
        contentView.addSubview(child.view)
        
        if let frame = frame {
            child.view.frame = frame
        } else {
            child.view.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

public extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        return initInNavigationController()
    }
    
    func initInNavigationController() -> UINavigationController {
        return UINavigationController.init(rootViewController: self)
    }
    
    func endViewController(animated: Bool? = nil) {
        if self.isModal {
            self.dismiss(animated: animated ?? true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: animated ?? true)
        }
    }
    
    
    struct Refresh {
        static var refreshCallBack: (() -> ())!
    }
    func addRefreshControl(title: String = "", inScrollView scrollView: UIScrollView, callback: (() -> ())? = nil) -> UIRefreshControl {
        if let callback = callback {
            Refresh.refreshCallBack = callback
        }
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(handleRefreshInExt(_:)), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
        return refreshControl
    }
    
    @objc private func handleRefreshInExt(_ refreshControl: UIRefreshControl) {
        Refresh.refreshCallBack()
    }
    
    func disableiOS13SwipeToDismiss() {
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func enableiOS13SwipeToDismiss() {
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    // 🌿 Set UIViewController to fullscreen if presented
    func setFullscreen() {
        self.modalPresentationStyle = .fullScreen
    }
}
