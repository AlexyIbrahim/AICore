//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 1/8/23.
//

import Foundation

public class DebugHelper {
    public final class func addBreadcrumb(forKey key: String, value: Any?) {
        CrashlyticsHelper.addBreadcrumb(forKey: key, value: value)
    }
    
    public final class func addBreadcrumbs(_ breadcrumbs: [String : Any]) {
        CrashlyticsHelper.addBreadcrumbs(breadcrumbs)
    }
    
    public final class func log(_ msg: String) {
        CrashlyticsHelper.log(msg)
    }
    
    public final class func log(key: String, value: Any) {
        CrashlyticsHelper.log(key: key, value: value)
    }
    
    public final class func log(dictionary: [String: Any]) {
        CrashlyticsHelper.log(dictionary: dictionary)
    }
    
    public final class func reportError(_ error: Error?, userInfo: [String: Any]? = nil) {
        CrashlyticsHelper.reportError(error, userInfo: userInfo)
    }
    
    public final class func reportException(_ exception: NSException) {
        CrashlyticsHelper.reportException(exception)
    }
    
    public final class func reportCustomException(name: String, reason: String) {
        CrashlyticsHelper.reportCustomException(name: name, reason: reason)
    }
}
