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
    
    public static var activityIndicator: UIActivityIndicatorView!
    
    public final class func showActivityIndicator(centeredWithView view:UIView, activityIndicatorStyle:UIActivityIndicatorView.Style?, tintColor:UIColor?) {
        AIActivityIndicator.showActivityIndicator(atPosition: view.snp.center, activityIndicatorStyle:activityIndicatorStyle, tintColor:tintColor)
    }
    
    private final class func showActivityIndicator(atPosition position: ConstraintItem, activityIndicatorStyle:UIActivityIndicatorView.Style?, tintColor:UIColor?) {
        DispatchQueue.main {
            AIActivityIndicator.activityIndicator = UIActivityIndicatorView()
            AIActivityIndicator.activityIndicator.hidesWhenStopped = true
            
            if let activityIndicatorStyle = activityIndicatorStyle {
                AIActivityIndicator.activityIndicator.style = activityIndicatorStyle
            }
            
            if let tintColor = tintColor {
                AIActivityIndicator.activityIndicator.color = tintColor
            }
            
            Utils.currentViewController()?.view.addSubview(AIActivityIndicator.activityIndicator)
            AIActivityIndicator.activityIndicator.snp.makeConstraints { (make) in
                make.center.equalTo(position)
            }
            Utils.currentViewController()?.view.bringSubviewToFront(AIActivityIndicator.activityIndicator)
            AIActivityIndicator.activityIndicator.startAnimating()
        }
    }
    
    public final class func stopAnimating() {
//        guard AIActivityIndicator.shared.activityIndicator != nil else {
//            print("AIActivityIndicator.shared.activityIndicator is nil")
//            return
//        }
        
        guard let activityIndicator = AIActivityIndicator.activityIndicator else {
            print("AIActivityIndicator.shared.activityIndicator is nil")
            return
        }
        DispatchQueue.main {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            AIActivityIndicator.activityIndicator = nil
        }
    }
    
}
