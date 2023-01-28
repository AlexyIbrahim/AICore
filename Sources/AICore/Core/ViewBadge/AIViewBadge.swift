//
//  AIViewBadge.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 1/4/23.
//

import Foundation
import UIKit
import SnapKit

public enum BadgeDirection {
    
    case upperRight
    case upperLeft
    case bottomRight
    case bottomLeft
    case center
    
}

public extension UIView {
    
    /// add a new badge to the view
    /// - Parameters:
    ///   - direction: where the view's x/y boundaries will be anchored
    @discardableResult func setBadge(in direction: BadgeDirection, with text: String) -> AIBadgeLabel {
        
        let badge = AIBadgeLabel(text: text)
        badge.accessibilityIdentifier = "badge"
        addSubview(badge)
        self.bringSubviewToFront(badge)
        setBadgeConstraintsInSafeArea(for: badge, in: direction)
        
        return badge
        
    }
    
    private func setBadgeConstraintsInSafeArea(for badge: AIBadgeLabel, in direction: BadgeDirection) {
        switch direction {
            
        case .center:
            badge.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        case .upperRight:
            badge.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(-10)
                make.trailing.equalToSuperview().offset(6)
            }
        case .upperLeft:
            badge.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(-10)
                make.leading.equalToSuperview().offset(-6)
            }
        case .bottomRight:
            badge.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(6)
            }
        case .bottomLeft:
            badge.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(-6)
            }
        }
        
    }
    
}
