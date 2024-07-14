//
//  UITextViewExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/14/22.
//

import Foundation
import UIKit

public extension UITextView {
    func isEmpty() -> Bool {
        guard let text = text, text.count > 0 else { return true }
        return false
    }

    func scrollToBottom() {
        if text.count > 0 {
            let location = text.count - 1
            let bottom = NSMakeRange(location, 1)
            scrollRangeToVisible(bottom)
        }
    }
}
