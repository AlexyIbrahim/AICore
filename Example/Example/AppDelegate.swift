//
//  AppDelegate.swift
//  Example
//
//  Created by Alexy Ibrahim on 8/28/23.
//

import AICore
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions")
        AIPermission.requestNotificationPermission(application: application) { _ in
        }

        return true
    }
}
