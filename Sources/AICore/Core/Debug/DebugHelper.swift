//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 1/8/23.
//

import Foundation

public class DebugHelper {
    public static var addCallerInfo: Bool = false
    
    public final class func addBreadcrumb(forKey key: String, value: Any?) {
        FirebaseCrashlyticsHelper.addBreadcrumb(forKey: key, value: value)
    }
    
    public final class func addBreadcrumbs(_ breadcrumbs: [String : Any]) {
        FirebaseCrashlyticsHelper.addBreadcrumbs(breadcrumbs)
    }
    
    public final class func log(_ msg: String, filename: String = #file, function : String = #function, line: Int = #line) {
        var finalMsg = msg
        if addCallerInfo {
            let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\t-> "
            finalMsg = pretty + finalMsg
        }
        DispatchQueue.background {
            FirebaseCrashlyticsHelper.log(finalMsg)
        }
    }
    
    public final class func log(key: String, value: Any, filename: String = #file, function : String = #function, line: Int = #line) {
        var finalMsg = "\(key): \(value)"
        if addCallerInfo {
            let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\t-> "
            finalMsg = pretty + finalMsg
        }
        DispatchQueue.background {
            FirebaseCrashlyticsHelper.log(finalMsg)
        }
    }
    
    public final class func log(_ dictionary: [String: Any], filename: String = #file, function : String = #function, line: Int = #line) {
        var finalMsg = dictionary.debugDescription
        if addCallerInfo {
            let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\t-> "
            finalMsg = pretty + finalMsg
        }
        DispatchQueue.background {
            FirebaseCrashlyticsHelper.log(finalMsg)
        }
    }
    
    public final class func log(message: String, dictionary: [String: Any], filename: String = #file, function : String = #function, line: Int = #line) {
        var finalMsg = message
        if addCallerInfo {
            let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\t-> "
            finalMsg = pretty + finalMsg
        }
        DispatchQueue.background {
            FirebaseCrashlyticsHelper.log(message: finalMsg, dictionary: dictionary)
        }
    }
    
    public final class func reportError(_ error: Error, userInfo: [String: Any]? = nil) {
        FirebaseCrashlyticsHelper.reportError(error, userInfo: userInfo)
    }
    
    public final class func reportCustomError(_ description: String, userInfo: [String: Any]? = nil, filename: String = #file, function : String = #function, line: Int = #line) {
        var finalMsg = description
        if addCallerInfo {
            let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\t-> "
            finalMsg = pretty + finalMsg
        }
        
        FirebaseCrashlyticsHelper.reportCustomError(finalMsg, userInfo: userInfo)
    }
    
    public final class func reportException(_ exception: NSException) {
        FirebaseCrashlyticsHelper.reportException(exception)
    }
    
    public final class func reportCustomException(name: String, reason: String? = nil) {
        FirebaseCrashlyticsHelper.reportCustomException(name: name, reason: reason)
    }
}
