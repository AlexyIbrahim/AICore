//
//  UINavigationControllerExtension.swift
//  AICore
//
//  Created by Alexy Ibrahim on 1/2/23.
//

import Foundation
import UIKit

public extension UINavigationController {
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return viewControllers.contains(where: { $0.isKind(of: kind) })
    }

//    func removeAnyViewControllers(ofKind kind: AnyClass) {
//        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
//    }

    func removeAnyViewControllers(ofKind kind: AnyClass) {
        viewControllers.removeAll(where: { vc -> Bool in
            if vc.isKind(of: kind) {
                return false
            } else {
                return true
            }
        })
    }
}
