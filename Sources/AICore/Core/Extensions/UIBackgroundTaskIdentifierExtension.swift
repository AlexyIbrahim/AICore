//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 4/10/23.
//

import Foundation
import UIKit

extension UIBackgroundTaskIdentifier {
    func end() {
        UIApplication.shared.endBackgroundTask(self)
    }
}
