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
            AIToast.show(title: "Pinged", subtitle: "Alexy Ibrahim", position: .top)

        }
        
        self.button_notification2.addAction {
            AIToast.show(title: "Error", subtitle: "Alexy Ibrahim", position: .top, backgroundColor: .error)
        }
    }


}

