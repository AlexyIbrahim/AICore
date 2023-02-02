//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 1/8/23.
//

import Foundation

public class DebugHelper {
    public final class func addBreadcrumb(forKey key: String, value: Any?) {
        FirebaseCrashlyticsHelper.addBreadcrumb(forKey: key, value: value)
    }
    
    public final class func addBreadcrumbs(_ breadcrumbs: [String : Any]) {
        FirebaseCrashlyticsHelper.addBreadcrumbs(breadcrumbs)
    }
    
    public final class func log(_ msg: String) {
        FirebaseCrashlyticsHelper.log(msg)
    }
    
    public final class func log(key: String, value: Any) {
        FirebaseCrashlyticsHelper.log(key: key, value: value)
    }
    
    public final class func log(dictionary: [String: Any]) {
        FirebaseCrashlyticsHelper.log(dictionary: dictionary)
    }
    
    public final class func reportError(_ error: Error?, userInfo: [String: Any]? = nil) {
        FirebaseCrashlyticsHelper.reportError(error, userInfo: userInfo)
    }
    
    public final class func reportException(_ exception: NSException) {
        FirebaseCrashlyticsHelper.reportException(exception)
    }
    
    public final class func reportCustomException(name: String, reason: String? = nil) {
        FirebaseCrashlyticsHelper.reportCustomException(name: name, reason: reason)
    }
}
