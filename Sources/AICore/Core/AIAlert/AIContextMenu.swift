//
//  AIContextMenu.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/13/22.
//

import Foundation
import UIKit

public class AIContextMenu {
   
    public struct MenuButton {
        let title: String
        let image: UIImage?
        let state: UIMenuElement.State
        let callback: (() -> ())?
        
        init(title: String, image: UIImage?, state: UIMenuElement.State, callback: (() -> ())? = nil) {
            self.title = title
            self.image = image
            self.state = state
            self.callback = callback ?? nil
        }
    }
    
    public final class func display(withTitle title:String, options: UIMenu.Options = .displayInline, buttons: [MenuButton]) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            var temp_buttons: [UIAction] = [UIAction]()
            for menu_button in buttons {
                let edit = UIAction(title: menu_button.title, image: menu_button.image, identifier: nil, discoverabilityTitle: nil, state: menu_button.state) { (_) in
                    menu_button.callback?()
                }
                temp_buttons.append(edit)
            }
            
            
            return UIMenu(title: title, image: nil, identifier: nil, options: options, children: temp_buttons)
        }
        return context
    }
    
    public final class func display(withTitle title:String, options: UIMenu.Options = .displayInline, buttons: MenuButton...) -> UIContextMenuConfiguration {
        return display(withTitle: title, options: options, buttons: buttons)
    }
}

extension UIView {
//    func addInteraction() {
//        let interaction = UIContextMenuInteraction(delegate: self)
//        self.addInteraction(interaction)
//    }
}
