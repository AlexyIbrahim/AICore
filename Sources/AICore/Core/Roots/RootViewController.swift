//
//  RootViewController.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/14/22.
//

import Foundation
import UIKit
import ProgressHUD
import RxSwift
import Combine

open class RootViewController: UIViewController {

    public let disposeBag = DisposeBag()
    public var observers: [AnyCancellable] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)   
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            
        }
    }
    
}

public extension RootViewController {
    func showProgress() {
        ProgressHelper.showProgress()
    }
    
    func hideProgress() {
        ProgressHelper.hideProgress()
    }
    
    func showProgressSuccess() {
        ProgressHelper.showProgressSuccess()
    }
    
    func showProgressError(_ msg: String? = nil) {
        ProgressHelper.showProgressError(msg)
    }
}

