//
//  AnalyticsHelper.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/23/22.
//

import Foundation
import FirebaseAnalytics

public class FirebaseAnalyticsHelper {
    public final class func setUserId(_ userId: String, userProperties: [String: String?]? = nil) {
        Analytics.setUserID(userId)
        userProperties?.forEach({ (key: String, value: String?) in
            FirebaseAnalyticsHelper.setUserProperty(forKey: key, value: value)
        })
    }
    
    public final class func setUserProperty(forKey key: String, value: String?) {
        Analytics.setUserProperty(value, forName: key)
    }
    
    public final class func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    public final class func logEvent(name: String, item_id: String? = nil, item_name: String, item_type: String? = nil) {
        logEvent(name: name, parameters: [
            AnalyticsParameterItemID: "id-\(item_name)",
            AnalyticsParameterItemName: item_name,
            AnalyticsParameterContentType: item_type ?? "cont",
        ])
    }
    
    public final class func logSignUp(method: String) {
        logEvent(name: AnalyticsEventSignUp, parameters: [AnalyticsParameterMethod: method])
    }
    
    public final class func logLogin(method: String) {
        logEvent(name: AnalyticsEventLogin, parameters: [AnalyticsParameterMethod: method])
    }
    
    public final class func logShare(contentId: String, contentType: String, content: String) {
        logEvent(name: AnalyticsEventShare, parameters: ["content_id": contentId,
                                                         AnalyticsParameterContentType: contentType,
                                                         AnalyticsParameterContent: content])
    }
    
}
