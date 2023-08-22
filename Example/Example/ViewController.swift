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
    @IBOutlet private var button_loading: AIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.button_notification.addAction {
            AIToast.show(title: "Pinged", subtitle: "Alexy Ibrahim", position: .top)

        }
        
        self.button_notification2.addAction {
            AIToast.show(title: "Error", subtitle: "Alexy Ibrahim", position: .top, backgroundColor: .error)
        }
		
		self.button_loading.setTitle("Click Here", for: .normal)
		self.button_loading.addAction {
			if self.button_loading.isLoading {
				self.button_loading.setLoading(false)
			} else {
				self.button_loading.setLoading(true)
			}
		}
    }

}

