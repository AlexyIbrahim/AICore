//
//  AIActivityIndicator.swift
//  ParkPro
//
//  Created by Alexy Ibrahim on 3/9/18.
//  Copyright © 2018 Alexy Ibrahim. All rights reserved.
//

import UIKit
import SnapKit

public class AIActivityIndicator: NSObject {
	
	static let shared = AIActivityIndicator()
	
	public var activityIndicator: UIActivityIndicatorView?
	
	public final class func showActivityIndicator(centeredWithView view:UIView, activityIndicatorStyle:UIActivityIndicatorView.Style?, tintColor:UIColor?) {
		AIActivityIndicator.shared.showActivityIndicator(centeredWithView: view, activityIndicatorStyle: activityIndicatorStyle, tintColor: tintColor)
	}
	
	public func showActivityIndicator(centeredWithView view:UIView, activityIndicatorStyle:UIActivityIndicatorView.Style?, tintColor:UIColor?) {
		DispatchQueue.main {
			self.activityIndicator = UIActivityIndicatorView()
			guard let activityIndicator = self.activityIndicator else {
				return
			}
			activityIndicator.hidesWhenStopped = true
			
			if let activityIndicatorStyle = activityIndicatorStyle {
				activityIndicator.style = activityIndicatorStyle
			}
			
			if let tintColor = tintColor {
				activityIndicator.color = tintColor
			}
			
			Utils.currentViewController()?.view.addSubview(activityIndicator)
			activityIndicator.snp.makeConstraints { (make) in
				make.center.equalTo(view.snp.center)
			}
			Utils.currentViewController()?.view.bringSubviewToFront(activityIndicator)
			activityIndicator.startAnimating()
		}
	}
	
	public final class func stopAnimating() {
		AIActivityIndicator.shared.stopAnimating()
	}
	
	public func stopAnimating() {
		guard let activityIndicator = self.activityIndicator else {
			print("activityIndicator is nil")
			return
		}
		DispatchQueue.main {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
			self.activityIndicator = nil
		}
	}
	
	public final class func setTintColor(_ aicolor: AIColor) {
		AIActivityIndicator.shared.setTintColor(aicolor)
	}
	
	public func setTintColor(_ aicolor: AIColor) {
		self.activityIndicator?.tintColor = aicolor.color
	}
	
}
