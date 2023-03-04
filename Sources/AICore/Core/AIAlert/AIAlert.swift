//
//  AIAlert.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/15/22.
//

import Foundation
import UIKit


public class AIAlert {
   
    public struct AlertTextField {
        public let placeholder: String
        public let keyboardType: UIKeyboardType
        
        public init(placeholder: String, keyboardType: UIKeyboardType? = nil) {
            self.placeholder = placeholder
            self.keyboardType = keyboardType ?? .default
        }
    }
    
    public struct AlertButton {
        public let title: String
        public let style: UIAlertAction.Style
        public let callback: ((_ textfields: [UITextField]?) -> ())?
        
        public init(title: String, style: UIAlertAction.Style? = nil, callback: ((_ textfields: [UITextField]?) -> ())? = nil) {
            self.title = title
            self.style = style ?? .default
            self.callback = callback ?? nil
        }
    }
    
    public final class func displayNativeMessage(message: String? = nil, withTitle title: String? = nil, style: UIAlertController.Style = .alert, buttons: [AlertButton], textFields: [AlertTextField]? = nil) {
        DispatchQueue.main({
            guard let viewController: UIViewController = Utils.topMostWindowController() else {
                return
            }
            
            let title:String? = ((title != nil) ? title!:nil)
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            if style == .alert {
                if let textFields = textFields {
                    for textfield in textFields {
                        alertViewController.addTextField { textfield_temp in
                            textfield_temp.placeholder = textfield.placeholder
                            textfield_temp.keyboardType = textfield.keyboardType
                        }
                    }
                }
            }
            
            for alert_button in buttons {
                alertViewController.addAction(UIAlertAction(title: alert_button.title, style: alert_button.style) { action in
                    alertViewController.dismiss(animated: true, completion: nil)
                    alert_button.callback?(alertViewController.textFields)
                })
            }
            
            alertViewController.popoverPresentationController?.sourceView = viewController.view
            alertViewController.popoverPresentationController?.sourceRect = viewController.view.bounds
            
            viewController.present(alertViewController, animated: true, completion: nil)
        })
    }
    
    public final class func displayNativeMessage(message: String? = nil, withTitle title: String? = nil, style: UIAlertController.Style = .alert, buttons: AlertButton..., textFields: AlertTextField?...) {
        let textfields = textFields.compactMap { $0 }
        displayNativeMessage(message: message, withTitle: title, style: style, buttons: buttons, textFields: textfields)
    }
}

public extension AIAlert.AlertButton {
    static let okay = AIAlert.AlertButton.init(title: "Okay", style: .default, callback: nil)
    static let cancel = AIAlert.AlertButton.init(title: "Cancel", style: .cancel, callback: nil)
    static let discard = AIAlert.AlertButton.init(title: "Discard", style: .cancel, callback: nil)
    static func yes(callback: ((_ textfields: [UITextField]?) -> ())? = nil) -> AIAlert.AlertButton {
        return AIAlert.AlertButton.init(title: "Yes", style: .default, callback: callback)
    }
    static func no(callback: ((_ textfields: [UITextField]?) -> ())? = nil) -> AIAlert.AlertButton {
        return AIAlert.AlertButton.init(title: "No", style: .default, callback: callback)
    }
}
