import AIEnvironmentKit
import Sentry
import UIKit

public class SentryHelper: NSObject {
    static let logSensitiveData: Bool = false

    // MARK: - init

    // MARK: sentry

    public final class func initSentry(dsn: String, callback: ((_ scope: Scope, _ options: Options) -> Void)? = nil) {
        SentrySDK.start { options in
            options.dsn = dsn
            options.debug = false

            // features
            options.enablePreWarmedAppStartTracing = true
            options.attachScreenshot = true
            options.attachViewHierarchy = true
            if #available(iOS 15.0, *) {
                options.enableMetricKit = true
            }
//                options.swiftAsyncStacktraces = true
//                options.enableOutOfMemoryTracking = true

            options.enableAppHangTracking = true
            options.appHangTimeoutInterval = 2
            options.tracesSampleRate = 1.0
            options.enableUIViewControllerTracing = true
            options.enableNetworkTracking = true
            options.enableFileIOTracing = false
            options.beforeBreadcrumb = { crumb in
                crumb
            }

            if !AIEnvironmentKit.isDebug, !AIEnvironmentKit.isDebuggerAttached {
                options.onCrashedLastRun = { _ in
                    // capture user feedback
//                        let eventId = SentrySDK.capture(event: event, scope: scope)
//
//                        let userFeedback = UserFeedback(eventId: eventId)
//                        userFeedback.comments = ""
//                        userFeedback.email = ""
//                        userFeedback.name = ""
//                        SentrySDK.capture(userFeedback: userFeedback)
                }
            }

            SentrySDK.configureScope { scope in
                let scope = SentryHelper.initScope(fromScope: scope)
                callback?(scope, options)
            }
        }
    }

    // MARK: sentry user

    public final class func setUser(id: String? = nil, username: String? = nil, email: String? = nil, data: [String: Any]? = nil) {
        let sentryUser = Sentry.User()
        sentryUser.userId = id
        sentryUser.username = username
        sentryUser.email = email
//        sentryUser.ipAddress = Utils.fetchPublicIP()
        sentryUser.data = data

        SentryHelper.setUser(sentryUser)
    }

    public final class func setUser(_ user: Sentry.User) {
        SentrySDK.setUser(user)
    }

    final class func clearUser() {
        SentrySDK.setUser(nil)
    }

    // MARK: init scope

    private final class func initScope(fromScope: Scope? = nil) -> Scope {
        // init
        var tempScope: Scope
        if let scope = fromScope {
            tempScope = scope
        } else {
            tempScope = Scope()
        }
        // settings vars
        tempScope.setEnvironment(AIEnvironmentKit.environmentName)
//        tempScope.setUser(SentryHelper.initSentryUser())
        tempScope.setContext(value: [
            "system_version": UIDevice.current.systemVersion,
            "name": UIDevice.current.name,
            "system_name": UIDevice.current.systemName,
            "model": UIDevice.current.model,
            "user_interface_idiom": "\(UIDevice.current.userInterfaceIdiom)",
            "orientation": "\(UIDevice.current.orientation)",
            "battery_state": "\(UIDevice.current.batteryState)",
            "battery_level": UIDevice.current.batteryLevel.description,
            "screen_size": "\(UIScreen.main.bounds.size.width) x \(UIScreen.main.bounds.size.height)",
            "identifier_for_vendor": "\(UIDevice.current.identifierForVendor?.uuidString ?? "")",
            "model_name": "\(UIDevice.current.modelName)",
        ], key: "Device")

        tempScope.setContext(value: [
            "appVersion": Utils.appVersion(),
            "build": Utils.build(),
        ], key: "App")

        tempScope.setTags([:])

        return tempScope
    }

    // MARK: - Breadcrumb

    public final class func addBreadcrumb<T>(clazz: T, category: SentryBreadcrumbCategory? = nil) {
        SentryHelper.addBreadcrumb(category: category ?? .view, message: String(describing: type(of: clazz)), level: .info, data: nil)
    }

    public final class func addBreadcrumb(category: SentryBreadcrumbCategory? = nil, message: String? = nil, level: SentryLevel? = nil, data: [String: Any]? = nil) {
        SentryHelper.addBreadcrumb(category: category?.value, message: message, level: level, data: data)
    }

    public final class func addBreadcrumb(category: String? = nil, message: String? = nil, level: SentryLevel? = nil, data: [String: Any]? = nil) {
        DispatchQueue.global(qos: .background).async {
            let breadcrumb = Breadcrumb()
            breadcrumb.level = level ?? .info
            if let category = category {
                breadcrumb.category = category
            }
            if let message = message {
                breadcrumb.message = message
            }
            if let data = data {
                breadcrumb.data = data
            }
            SentrySDK.addBreadcrumb(breadcrumb)
        }
    }

    // Capture a message
    public final class func captureMessage(_ message: String, level: SentryLevel? = nil, tags: [String: String]?, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let callback = callback {
                SentrySDK.capture(message: message) { scope in
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
                let scope = Scope()
                scope.setLevel(level ?? .warning)
                if let tags = tags {
                    scope.setTags(tags)
                }
                if let extras = extras {
                    scope.setExtras(extras)
                }

                SentrySDK.capture(message: message, scope: scope)
            }
        }
    }

    // MARK: - Exception

    public final class func reportException(_ exception: NSException, level: SentryLevel? = nil, tags: [String: String]?, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let callback = callback {
                SentrySDK.capture(exception: exception) { scope in
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
                let scope = Scope()
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

    public final class func reportCustomException(name: String, reason: String, level: SentryLevel? = nil, tags: [String: String]?, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            let exception = NSException(name: NSExceptionName(name), reason: reason, userInfo: nil)

            if let callback = callback {
                SentrySDK.capture(exception: exception) { scope in
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
                let scope = Scope()
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

    public final class func reportError(_ error: Error?, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            guard let error = error else {
                return
            }
            if let callback = callback {
                SentrySDK.capture(error: error) { scope in
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
                let scope = Scope()
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

    public final class func reportCustomError(domain: String, reason: String, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            let error = NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: reason])
            if let callback = callback {
                SentrySDK.capture(error: error) { scope in
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
                let scope = Scope()
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

    public final class func reportEvent(reason: String, level: SentryLevel? = nil, tags: [String: String]? = nil, extras: [String: Any]? = nil, callback: ((_ scope: Scope) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            let event = Event(level: level ?? .warning)

            event.message = SentryMessage(formatted: reason)
            event.environment = AIEnvironmentKit.environmentName

            if let callback = callback {
                SentrySDK.capture(event: event) { scope in
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
                let scope = Scope()
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

    // Flush events to Sentry
    public final class func flushEvents(timeout: TimeInterval? = nil) {
        SentrySDK.flush(timeout: timeout ?? 0)
    }

    public class func startTransaction(_ name: String, operation: String, bindToScope: Bool? = nil, data: [String: Any]? = nil, tags: [String: String]? = nil, measurements: [String: NSNumber]? = nil) -> Sentry.Span? {
        let transaction = SentrySDK.startTransaction(name: name, operation: operation, bindToScope: bindToScope ?? false)
        data?.forEach { (key: String, value: Any) in
            transaction.setData(value: value, key: key)
        }
        tags?.forEach { (key: String, value: String) in
            transaction.setTag(value: value, key: key)
        }
        measurements?.forEach { (key: String, value: NSNumber) in
            transaction.setMeasurement(name: key, value: value)
        }

        return transaction
    }

    public class func startChild(transaction: Sentry.Span, operation: String, description: String? = nil, data: [String: Any]? = nil, tags: [String: String]? = nil, measurements: [String: NSNumber]? = nil) -> Sentry.Span? {
        let transaction = transaction.startChild(operation: operation, description: description)
        data?.forEach { (key: String, value: Any) in
            transaction.setData(value: value, key: key)
        }
        tags?.forEach { (key: String, value: String) in
            transaction.setTag(value: value, key: key)
        }
        measurements?.forEach { (key: String, value: NSNumber) in
            transaction.setMeasurement(name: key, value: value)
        }

        return transaction
    }
}

// helpers
public extension SentryHelper {
    // MARK: - SentryBreadcrumbCategory enum

    enum SentryBreadcrumbCategory {
        case view
        case viewDidLoad
        case viewWillAppear
        case viewDidAppear
        case viewWillDisappear
        case viewDidDisappear
        case controlledDismissed
        case buttonClick
        case apiCall
        case apiFired
        case apiCallSuccess
        case apiCallError
        case functionCalled
        case functionBody
        case message
        case custom(message: String)

        var value: String! {
            switch self {
            case .viewDidLoad:
                return "View Did Load"
            case .viewWillAppear:
                return "View Will Appear"
            case .viewDidAppear:
                return "View Did Appear"
            case .viewWillDisappear:
                return "View Will Disappear"
            case .viewDidDisappear:
                return "View Did Disappear"
            case .controlledDismissed:
                return "Controlled Dismissed"
            case .buttonClick:
                return "Button Click"
            case .apiCall:
                return "API Call"
            case .apiFired:
                return "API Fired"
            case .apiCallSuccess:
                return "API Call Success"
            case .apiCallError:
                return "API Call Error"
            case .functionCalled:
                return "Function Called"
            case .message:
                return "Message"
            case .view:
                return "View"
            case let .custom(message):
                return "\(message)"
            case .functionBody:
                return "Function Body"
            }
        }
    }
}
