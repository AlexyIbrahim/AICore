//
//  RootViewController.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/14/22.
//

import Combine
import Foundation
import ProgressHUD
import UIKit

open class RootViewController: UIViewController {
	
    public var cancellables = Set<AnyCancellable>()
	
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	// Required initializer when instantiating from storyboard
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override open func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override open func motionBegan(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
        if motion == .motionShake {}
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
