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
    @IBOutlet private var button_notification2: AIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.button_notification.addAction {
            AIToast.show(message: "Hello world", position: .top, backgroundColor: .blackWhite, textColor: .whiteBlack, leftImage: nil)
        }
        
        self.button_notification2.addAction {
            AIToast.show(message: "Successsss", position: .top, backgroundColor: .success, textColor: .blackWhite, leftImage: nil)
        }
    }


}

