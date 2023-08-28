//
//  AppDelegate.swift
//  Example
//
//  Created by Alexy Ibrahim on 8/28/23.
//

import Foundation
import UIKit
import AICore

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		print("didFinishLaunchingWithOptions")
		AIPermission.requestNotificationPermission(application: application) { granted in
			
		}
		
		return true
	}
}
