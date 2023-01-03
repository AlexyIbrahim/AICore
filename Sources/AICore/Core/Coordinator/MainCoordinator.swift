//
//  MainCoordinator.swift
//  Fibler2
//
//  Created by Alexy Ibrahim on 9/20/19.
//  Copyright © 2019 siegma. All rights reserved.
//
import Foundation
import UIKit

@objcMembers public class MainCoordinator: Coordinator {
    public static let shared = MainCoordinator()
    
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    var presentedViewController: UIViewController?
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Utils
public extension MainCoordinator {
    final class func pushViewController(_ viewController: UIViewController, animated: Bool? = nil, removePreviousVCs: Bool? = nil, dismissPresentedViewController: Bool? = nil) {
        if removePreviousVCs ?? false || dismissPresentedViewController ?? false {
            self.dismissPresentedViewController()
        }
        if removePreviousVCs ?? false {
            MainCoordinator.shared.navigationController.viewControllers.removeAll()
            MainCoordinator.shared.navigationController.viewControllers = [viewController]
        } else {
            MainCoordinator.shared.navigationController.pushViewController(viewController, animated: animated ?? true)
//            if !MainCoordinator.shared.navigationController.containsViewController(ofKind: type(of: viewController)) {
//                MainCoordinator.shared.navigationController.pushViewController(viewController, animated: animated ?? true)
//            }
        }
    }
    
    final class func present(_ viewController: UIViewController,fullScreen: Bool? = nil, animated: Bool? = nil, dismissPresentedViewController: Bool? = nil, completion: (() -> ())? = nil) {
        if dismissPresentedViewController ?? false {
            self.dismissPresentedViewController()
        }
        MainCoordinator.shared.presentedViewController = viewController
        if fullScreen ?? false {
            viewController.setFullscreen()
        }
        MainCoordinator.shared.navigationController.present(viewController, animated: animated ?? true, completion: completion)
    }
    
    final class func popToRootViewController(animated: Bool? = nil, dismissPresentedViewController: Bool? = nil) {
        if dismissPresentedViewController ?? false {
            self.dismissPresentedViewController()
        }
        MainCoordinator.shared.navigationController.popToRootViewController(animated: animated ?? true)
    }
    
    final class func popCurrentViewController(animated: Bool? = nil, dismissPresentedViewController: Bool? = nil) {
        if dismissPresentedViewController ?? false {
            self.dismissPresentedViewController()
        }
        MainCoordinator.shared.navigationController.popViewController(animated: animated ?? true)
    }
    
    final class func dismissPresentedViewController() {
        if let viewController = MainCoordinator.shared.presentedViewController  {
            if viewController.isModal {
                viewController.dismiss(animated: true, completion: nil)
                MainCoordinator.shared.presentedViewController = nil
            } else { // clear it, since something is wrong
                MainCoordinator.shared.presentedViewController = nil
            }
        }
    }
    
    final class func enableLargeTitles() {
        MainCoordinator.shared.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    final class func disableLargeTitles() {
        MainCoordinator.shared.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    final class func setLargeTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) {
        MainCoordinator.shared.navigationController.navigationItem.largeTitleDisplayMode = mode
    }
    
    final class func setNavigationTintColor(_ color: UIColor) {
        MainCoordinator.shared.navigationController.navigationBar.tintColor = color
    }
}

// MARK: - Navigation
extension MainCoordinator {
    // MARK: Start
    public func start() {
        MainCoordinator.start()
    }
    
    // 🌿 Display landing page
    class func start() {
    }
    
}
