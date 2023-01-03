
import Foundation
import UIKit
import Sentry
import AIEnvironmentKit

public class SentryHelper: NSObject {
    // MARK: - init
    // MARK: sentry
    public final class func initSentry() {
        do {
            SentrySDK.start(options: [
                "dsn": "Config.SENTRY_DSN",
                "enableAutoSessionTracking": true
            ])
            _ = SentryHelper.initSentryUser()
        } catch let error {
            print("sentry error: \(error)")
        }
    }

    // MARK: configure scope
    public final class func configure<T>(clazz: T) {
        SentrySDK.configureScope { (scope) in
            let _ = SentryHelper.initScope(scope)
            scope.setExtra(value: String(describing: type(of: clazz)), key: "Current View Controller")
        }
    }

    // MARK: sentry user
    public final class func initSentryUser() -> Sentry.User? {
        if Session.shared.isLoggedIn {
            let user = User.init()
            user.userId = ""
            user.username = ""
            user.email = ""
            user.data = [:]
            SentrySDK.setUser(user)
            return user
        }
        return nil
    }

    // MARK: init scope
    private final class func initScope(_ scope: Scope? = nil) -> Scope {
        // init
        var tempScope:Scope
        if let scope = scope {
            tempScope = scope
        } else {
            tempScope = Scope()
        }
        // settings vars
        tempScope.setEnvironment(AIEnvironmentKit.environmentName)
        tempScope.setUser(SentryHelper.initSentryUser())
        tempScope.setTag(value: Config.environmentDisplayName, key: "shelvz environment")
        tempScope.setTag(value: "swift", key: "language")
        
        return tempScope
    }

    // MARK: - SentryBreadcrumbCategory enum
    public enum SentryBreadcrumbCategory:String {
        case viewDidLoad = "ViewDidLoad"
        case viewWillAppear = "ViewWillAppear"
        case viewDidAppear = "ViewDidAppead"
        case viewWillDisappear = "ViewWillDisappear"
        case viewDidDisappear = "ViewDidDisappear"
        case controlledDismissed = "ControlledDismissed"
        case buttonClick = "ButtonClick"
        case apiCall = "APICall"
        case apiFired = "APIFired"
        case apiCallSuccess = "ApiCallSuccess"
        case apiCallError = "ApiCallError"
        case functionCalled = "FunctionCalled"
        case functionBody = "FuntionBody"
        case message = "Message"
        case socketMessage = "SocketMessage"
    }

    // MARK: - Breadcrumb
    public final class func addBreadcrumb(category: SentryBreadcrumbCategory, message: String? = nil, level: SentryLevel? = nil, data: [String: Any]? = nil) {
        DispatchQueue.global(qos: .background).async {
            let breadcrumb = Breadcrumb()
            breadcrumb.level = level ?? .info
            breadcrumb.category = category.rawValue
            if let message = message {
                breadcrumb.message = message
            }
            if let data = data {
                breadcrumb.data = data
            }
            SentrySDK.addBreadcrumb(crumb: breadcrumb)
        }
    }

    // MARK: - Exception
    public final class func reportException(_ exception: NSException, level: SentryLevel? = nil, tags: [String: String]?, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let callback = callback {
                SentrySDK.capture(exception: exception) { (scope) in
                    let _ = SentryHelper.initScope(scope)
                    scope.setLevel(level ?? .warning)
                    if let tags = tags {
                        scope.setTags(tags)
                    }
                    if let extras = extras {
                        scope.setExtras(extras)
                    }
                    
                    callback(scope)
                }
            } else {
                let scope = SentryHelper.initScope()
                scope.setLevel(level ?? .warning)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }
                
                SentrySDK.capture(exception: exception, scope: scope)
            }
        }
    }

    // MARK: - Custom Exception
    public final class func reportCustomException(name: String, reason: String, level: SentryLevel? = nil, tags: [String: String]?, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
            let exception = NSException(name: NSExceptionName(name), reason: reason, userInfo: nil)
            
            if let callback = callback {
                SentrySDK.capture(exception: exception) { (scope) in
                    let _ = SentryHelper.initScope(scope)
                    scope.setLevel(level ?? .warning)
                    if let tags = tags {
                        scope.setTags(tags)
                    }
                    if let extras = extras {
                        scope.setExtras(extras)
                    }
                    
                    callback(scope)
                }
            } else {
                let scope = SentryHelper.initScope()
                scope.setLevel(level ?? .warning)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }
                
                SentrySDK.capture(exception: exception, scope: scope)
            }
        }
    }

    // MARK: - Error
    public final class func reportError(_ error: Error?, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
            guard let error = error else {
                return
            }
            if let callback = callback {
                SentrySDK.capture(error: error) { (scope) in
                    let _ = SentryHelper.initScope(scope)
                    scope.setLevel(level ?? .error)
                    if let tags = tags {
                        scope.setTags(tags)
                    }
                    if let extras = extras {
                        scope.setExtras(extras)
                    }

                    callback(scope)
                }
            } else {
                let scope = SentryHelper.initScope()
                scope.setLevel(level ?? .error)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }

                SentrySDK.capture(error: error, scope: scope)
            }
        }
    }

    // MARK: - Custom Error
    public final class func reportCustomError(domain: String, reason: String, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
            let error = NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey : reason])
            if let callback = callback {
                SentrySDK.capture(error: error) { (scope) in
                    let _ = SentryHelper.initScope(scope)
                    scope.setLevel(level ?? .error)
                    if let tags = tags {
                        scope.setTags(tags)
                    }
                    if let extras = extras {
                        scope.setExtras(extras)
                    }
                    
                    callback(scope)
                }
            } else {
                let scope = SentryHelper.initScope()
                scope.setLevel(level ?? .error)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }
                
                SentrySDK.capture(error: error, scope: scope)
            }
        }
    }

    // MARK: - Event
    public final class func reportEvent(reason: String, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
            let event = Event(level: .warning)
            
            event.message = SentryMessage.init(formatted: reason)
            event.environment = AIEnvironmentKit.environmentName
            
            if let callback = callback {
                SentrySDK.capture(event: event) { (scope) in
                    let _ = SentryHelper.initScope(scope)
                    scope.setLevel(level ?? .warning)
                    if let tags = tags {
                        scope.setTags(tags)
                    }
                    if let extras = extras {
                        scope.setExtras(extras)
                    }
                    
                    callback(scope)
                }
            } else {
                let scope = SentryHelper.initScope()
                scope.setLevel(level ?? .warning)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }
                
                SentrySDK.capture(event: event, scope: scope)
            }
        }
    }
}
