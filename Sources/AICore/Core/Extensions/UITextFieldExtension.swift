//
// Created by Alexy Ibrahim on 10/18/22.
//

import Foundation
import UIKit

public extension UITextField {
    func isEmpty() -> Bool {
        guard let text = self.text, text.count > 0 else { return true }
        return false
    }
}
