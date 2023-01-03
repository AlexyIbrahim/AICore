//
//  ProgressHelper.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import ProgressHUD

public struct ProgressHelper {
    public static func showProgress(_ msg: String? = nil) {
        ProgressHUD.show(msg, interaction: false)
    }
    
    public static func hideProgress() {
        ProgressHUD.dismiss()
    }
    
    public static func showProgressSuccess(_ msg: String? = nil) {
        ProgressHUD.showSucceed(msg)
    }
    
    public static func showProgressError(_ msg: String? = nil) {
        ProgressHUD.showFailed(msg, interaction: false)
    }
}
