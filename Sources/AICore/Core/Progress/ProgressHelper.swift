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

    public static func showProgressSuccess(_ msg: String? = nil, interaction: Bool = false) {
        ProgressHUD.succeed(msg, interaction: interaction)
    }

    public static func showProgressError(_ msg: String? = nil) {
        ProgressHUD.error(msg, interaction: false)
    }

    public static func showProgressError(_ msg: String? = nil, interaction: Bool = false) {
        ProgressHUD.error(msg, interaction: interaction)
    }

    public static func showProgressSuccessWithDelay(_ msg: String? = nil, delay: TimeInterval = 2.0) {
        ProgressHUD.succeed(msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }

    public static func showProgressErrorWithDelay(_ msg: String? = nil, delay: TimeInterval = 2.0) {
        ProgressHUD.error(msg, interaction: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }

    public static func showBanner(_ text: String? = nil, delay: TimeInterval = 2.0) {
        ProgressHUD.banner(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }

    public static func showBanner(_ text: String? = nil, _ type: AnimationType, delay: TimeInterval = 2.0) {
        ProgressHUD.banner(text, type)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }

    public static func showBanner(_ text: String? = nil, symbol: String, delay: TimeInterval = 2.0) {
        ProgressHUD.banner(text, symbol: symbol)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }

    public static func showProgressWithCompletion(_ text: String? = nil, interaction: Bool = false, completion: @escaping () -> Void) {
        ProgressHUD.animate(text, interaction: interaction)
        completion()
    }

    public static func removeAll() {
        ProgressHUD.remove()
    }
}
