//
// Created by Alexy Ibrahim on 10/18/22.
//

import Foundation
import UIKit

public extension UITextField {
    func isEmpty() -> Bool {
        guard let text = text, text.count > 0 else { return true }
        return false
    }

    func dismissOnReturn() {
        UITextFieldRoot.shared.dismissOnReturn = true
        delegate = UITextFieldRoot.shared
    }

    func stopDismissIngOnReturn() {
        UITextFieldRoot.shared.dismissOnReturn = false
        delegate = nil
    }
}

class UITextFieldRoot: NSObject, UITextFieldDelegate {
    static let shared = UITextFieldRoot()
    var dismissOnReturn: Bool! = false

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if dismissOnReturn {
            textField.resignFirstResponder()
        }
        return true
    }
}
