//
//  Storyboarded.swift
//  Fibler2
//
//  Created by Alexy Ibrahim on 9/20/19.
//  Copyright © 2019 siegma. All rights reserved.
//

import Foundation
import UIKit

@objc protocol Storyboarded {
    static func instantiate() -> Self
}

public enum Storyboard {
    case naStoryboard
    case main

    var label: String {
        switch self {
        case .naStoryboard: return ""
        case .main: return "Main"
        }
    }
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

public extension UIViewController {
    static func classNameAsString() -> String {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        // this splits by the dot and uses everything after, giving "MyViewController"
        let components = fullName.components(separatedBy: ".")
        let className = (components.count > 1) ? components[1] : fullName
        return className
    }

    static func instantiate(withIdentifier viewControllerIdentifier: String?, fromStoryboard storyboard: Storyboard?) -> Self {
        let storyboard = UIStoryboard(name: storyboard?.label ?? "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier ?? classNameAsString()) as! Self

        return viewController
    }

    static func instantiateInitialViewController(fromStoryboard storyboard: Storyboard?) -> Self {
        let storyboard = UIStoryboard(name: storyboard?.label ?? "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! Self

        return viewController
    }
}

extension UIViewController {
    enum StoryboardedHolder {
        static var _executeOnDismiss = [String: (() -> Void)?]()
    }

    var executeOnDismiss: (() -> Void)? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return StoryboardedHolder._executeOnDismiss[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            StoryboardedHolder._executeOnDismiss[tmpAddress] = newValue
        }
    }
}
