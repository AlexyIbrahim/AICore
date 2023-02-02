//
//  CrashlyticsHelper.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/23/22.
//

import Foundation
import FirebaseCrashlytics

public class FirebaseCrashlyticsHelper: NSObject {
    public final class func initUser(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
        
        addBreadcrumb(forKey: "appVersion", value: Utils.appVersion())
        addBreadcrumb(forKey: "build", value: Utils.build())
    }
    
    public final class func addBreadcrumb(forKey key: String, value: Any?) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    public final class func addBreadcrumbs(_ breadcrumbs: [String : Any]) {
        Crashlytics.crashlytics().setCustomKeysAndValues(breadcrumbs)
    }
    
    public final class func log(_ msg: String) {
        Crashlytics.crashlytics().log(msg)
    }
    
    public final class func log(key: String, value: Any) {
        log([key: value])
    }
    
    public final class func log(_ dictionary: [String: Any]) {
        log(dictionary.debugDescription)
    }
    
    public final class func log(message: String, dictionary: [String: Any]) {
        log("\(message) , data: \(dictionary.debugDescription)")
    }
    
    public final class func reportError(_ error: Error, userInfo: [String: Any]? = nil) {
        Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
    }
    
    public final class func reportCustomError(_ name: String, userInfo: [String: Any]? = nil) {
        reportError(MyError.error(name), userInfo: userInfo)
    }
    
    public final class func reportException(_ exception: NSException) {
        Crashlytics.crashlytics().record(exceptionModel: ExceptionModel.init(name: exception.name.rawValue, reason: exception.reason ?? ""))
    }
    
    public final class func reportCustomException(name: String, reason: String? = nil) {
        reportException(NSException.init(name: NSExceptionName(name), reason: reason))
    }
    
    public final class func setCrashlyticsCollectionEnabled(_ value: Bool) {
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(value)
    }
    
    public final class func enableCrashlyticsCollection() {
        setCrashlyticsCollectionEnabled(true)
    }
    
    public final class func disableCrashlyticsCollection() {
        setCrashlyticsCollectionEnabled(false)
    }
}
