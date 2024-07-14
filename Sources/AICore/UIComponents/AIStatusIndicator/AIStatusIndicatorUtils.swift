//
//  AIStatusIndicatorUtils.swift
//  Story Crafter
//
//  Created by Alexy Ibrahim on 6/13/20.
//  Copyright © 2020 Alexy Ibrahim. All rights reserved.
//

import UIKit

class AIStatusIndicatorUtils: NSObject {
    final class func topMostWindowController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }

        return topController
    }

    final class func disassembleFrame(_ frame: CGRect) -> (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, xWidth: CGFloat, yHeight: CGFloat) {
        let x: CGFloat = frame.origin.x
        let y: CGFloat = frame.origin.y
        let width: CGFloat = frame.size.width
        let height: CGFloat = frame.size.height
        let xWidth: CGFloat = x + width
        let yHeight: CGFloat = y + height

        return (x, y, width, height, xWidth, yHeight)
    }
}
