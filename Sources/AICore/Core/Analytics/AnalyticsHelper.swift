//
//  AnalyticsHelper.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/23/22.
//

import Foundation

public class AnalyticsHelper {
    public final class func setUserId(_ userId: String, userProperties: [String: String?]? = nil) {
        FirebaseAnalyticsHelper.setUserId(userId, userProperties: userProperties)
    }

    public final class func setUserProperty(forKey key: String, value: String?) {
        FirebaseAnalyticsHelper.setUserProperty(forKey: key, value: value)
    }

    public final class func logEvent(name: String, parameters: [String: Any]? = nil) {
        FirebaseAnalyticsHelper.logEvent(name: name, parameters: parameters)
    }

    public final class func logEvent(name: String, item_id: String? = nil, item_name: String, item_type: String? = nil) {
        FirebaseAnalyticsHelper.logEvent(name: name, item_id: item_id, item_name: item_name, item_type: item_type)
    }

    public final class func logSignUp(method: String) {
        FirebaseAnalyticsHelper.logSignUp(method: method)
    }

    public final class func logLogin(method: String) {
        FirebaseAnalyticsHelper.logLogin(method: method)
    }

    public final class func logShare(contentId: String, contentType: String, content: String) {
        FirebaseAnalyticsHelper.logShare(contentId: contentId, contentType: contentType, content: content)
    }
}
