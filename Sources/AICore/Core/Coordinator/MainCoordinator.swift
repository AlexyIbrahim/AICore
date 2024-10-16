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
	var currentViewController: UIViewController?
	var presentedViewController: UIViewController?
	
	public static var currentViewController: UIViewController? {
		MainCoordinator.shared.currentViewController
	}
	
	public static var presentedViewController: UIViewController? {
		MainCoordinator.shared.presentedViewController
	}
	
	convenience init() {
		self.init(navigationController: UINavigationController())
	}
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

// MARK: - Utils

public extension MainCoordinator {
	final class func pushViewController(_ viewController: UIViewController, animated: Bool? = nil, removePreviousVCs: Bool? = nil, dismissPresentedViewController: Bool? = nil, hideNavigationBar: Bool = false) {
		if removePreviousVCs ?? false || dismissPresentedViewController ?? false {
			self.dismissPresentedViewController()
		}
		MainCoordinator.shared.currentViewController = viewController
		
		// Conditionally hide or show the navigation bar
		MainCoordinator.shared.navigationController.setNavigationBarHidden(hideNavigationBar, animated: animated ?? true)
		
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
	
	final class func present(_ viewController: UIViewController, fullScreen: Bool? = nil, animated: Bool? = nil, dismissPresentedViewController: Bool? = nil, hideNavigationBar: Bool = false, completion: (() -> Void)? = nil) {
		if dismissPresentedViewController ?? false {
			self.dismissPresentedViewController()
		}
		MainCoordinator.shared.presentedViewController = viewController
		if fullScreen ?? false {
			viewController.setFullscreen()
		}
		
		// Conditionally hide or show the navigation bar
		MainCoordinator.shared.navigationController.setNavigationBarHidden(hideNavigationBar, animated: animated ?? true)
		
		MainCoordinator.shared.navigationController.present(viewController, animated: animated ?? true, completion: completion)
	}
	
	final class func popToRootViewController(animated: Bool? = nil, dismissPresentedViewController: Bool? = nil) {
		if dismissPresentedViewController ?? false {
			self.dismissPresentedViewController()
		}
		MainCoordinator.shared.navigationController.popToRootViewController(animated: animated ?? true)
		MainCoordinator.shared.currentViewController = MainCoordinator.shared.navigationController.topViewController
	}
	
	final class func popCurrentViewController(animated: Bool? = nil, dismissPresentedViewController: Bool? = nil) {
		if dismissPresentedViewController ?? false {
			self.dismissPresentedViewController()
		}
		MainCoordinator.shared.navigationController.popViewController(animated: animated ?? true)
		MainCoordinator.shared.currentViewController = MainCoordinator.shared.navigationController.topViewController
	}
	
	final class func dismissPresentedViewController(_ animated: Bool? = nil) {
		if let viewController = MainCoordinator.shared.presentedViewController {
			if viewController.isModal {
				viewController.dismiss(animated: animated ?? true, completion: nil)
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
	
	final class func setHideBackButtonTitle(_ isHidden: Bool) {
		if isHidden {
			let barButtonAppearance = UIBarButtonItem.appearance()
			barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
		} else {
			let barButtonAppearance = UIBarButtonItem.appearance()
			barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .default)
		}
	}
}

// MARK: - Navigation

extension MainCoordinator {
	// MARK: Start
	
	public func start() {
		MainCoordinator.start()
	}
	
	// 🌿 Display landing page
	class func start() {}
}
