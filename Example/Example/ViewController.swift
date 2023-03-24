//
//  ViewController.swift
//  Example
//
//  Created by Alexy Ibrahim on 3/24/23.
//

import UIKit
import AICore

class ViewController: UIViewController {

    @IBOutlet private var button_notification: AIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.button_notification.addAction {
            AIToast.plainLoaf(message: "Pinged \(recipient_user.fullName)",
                                                  position: .top,
                                                  fontSize: 12,
                                                  bgColor: AIColor.blackWhite.color,
                                                  fontColor: AIColor.whiteBlack.color,
                                                  animationDirection: .top,
                                                  offset: 80)
        }
    }


}

