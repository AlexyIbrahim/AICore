//
//  ProgressHelper.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import ProgressHUD

public enum ProgressHelper {
    public static func showProgress(_ text: String? = nil, interaction: Bool = false) {
		ProgressHUD.animate(text, interaction: interaction)
    }

    public static func showProgress(_ text: String? = nil, _ type: AnimationType, interaction: Bool = false) {
        ProgressHUD.animate(text, type, interaction: interaction)
    }

    public static func showProgress(_ text: String? = nil, symbol: String, interaction: Bool = false) {
        ProgressHUD.animate(text, symbol: symbol, interaction: interaction)
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
