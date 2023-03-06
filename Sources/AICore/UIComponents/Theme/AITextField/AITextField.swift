//
//  AITextField.swift
//  
//
//  Created by Alexy Ibrahim on 3/6/23.
//

import UIKit

public class AITextField: UITextField {

    public var deleteBackwardCallback: ((_ textfield: UITextField) -> Void)?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public override func deleteBackward() {
        super.deleteBackward()
        
        self.deleteBackwardCallback?(self)
    }

}
