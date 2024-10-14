//
//  ProgressHelper.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import ProgressHUD

public enum ProgressHelper {
    public static func showProgress(_ msg: String? = nil) {
		ProgressHUD.animate(msg, interaction: false)
    }

    public static func hideProgress() {
        ProgressHUD.dismiss()
    }

    public static func showProgressSuccess(_ msg: String? = nil) {
        ProgressHUD.succeed(msg)
    }

    public static func showProgressError(_ msg: String? = nil) {
        ProgressHUD.error(msg, interaction: false)
    }
}
