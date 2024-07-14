//
//  Session.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation

public protocol SessionExtensions {}
public class Session: SessionExtensions {
    public static let shared = Session()

    var debuggingEnabled: Bool {
        get {
            Session.getLocalValue(keyPath: \.debuggingEnabled) ?? false
        }
        set {
            Session.saveLocally(keyPath: \.debuggingEnabled, withValue: newValue)
        }
    }

    public static var debuggingEnabled: Bool {
        get {
            Session.shared.debuggingEnabled
        }
        set {
            Session.shared.debuggingEnabled = newValue
        }
    }

    var errorDebuggingEnabled: Bool {
        get {
            Session.getLocalValue(keyPath: \.errorDebuggingEnabled) ?? false
        }
        set {
            Session.saveLocally(keyPath: \.errorDebuggingEnabled, withValue: newValue)
        }
    }

    public static var errorDebuggingEnabled: Bool {
        get {
            Session.shared.errorDebuggingEnabled
        }
        set {
            Session.shared.errorDebuggingEnabled = newValue
        }
    }

    var isLoggedIn: Bool {
        get {
            Session.getLocalValue(keyPath: \.isLoggedIn) ?? false
        }
        set {
            Session.saveLocally(keyPath: \.isLoggedIn, withValue: newValue)
        }
    }

    public static var isLoggedIn: Bool {
        get {
            Session.shared.isLoggedIn
        }
        set {
            Session.shared.isLoggedIn = newValue
        }
    }

    var allowScreenshots: Bool {
        get {
            Session.getLocalValue(keyPath: \.allowScreenshots) ?? true
        }
        set {
            Session.saveLocally(keyPath: \.allowScreenshots, withValue: newValue)
        }
    }

    public static var allowScreenshots: Bool {
        get {
            Session.shared.allowScreenshots
        }
        set {
            Session.shared.allowScreenshots = newValue
        }
    }
}

private let SESSION_KEY = "Session"
extension PartialKeyPath where Root == Session {
    var localValue: String {
        switch self {
        case \Session.isLoggedIn: return SESSION_KEY + "_" + "isLoggedIn"
        case \Session.debuggingEnabled: return SESSION_KEY + "_" + "debuggingEnabled"
        case \Session.errorDebuggingEnabled: return SESSION_KEY + "_" + "errorDebuggingEnabled"
        case \Session.allowScreenshots: return SESSION_KEY + "_" + "allowScreenshots"
        default:
            print("Unexpected key path: \(self)")
//            fatalError("Unexpected key path")
            return ""
        }
    }
}

public extension SessionExtensions where Self: Session {
    func saveLocally(inKey key: String, withValue value: Any) {
        Utils.saveUserDefault(inKey: key, withValue: value)
    }
}

public extension Session {
    final class func saveLocally<T>(keyPath: KeyPath<Session, T>, withValue value: Any) {
        Session.shared.saveLocally(inKey: keyPath.localValue, withValue: value)
    }

    final class func getLocalValue(keyPath: KeyPath<Session, String>) -> String? {
        return Utils.fetchUserDefault(key: keyPath.localValue)
    }

    final class func getLocalValue(keyPath: KeyPath<Session, Int>) -> Int? {
        return Utils.fetchUserDefault(key: keyPath.localValue)
    }

    final class func getLocalValue(keyPath: KeyPath<Session, Bool>) -> Bool? {
        return Utils.fetchUserDefault(key: keyPath.localValue)
    }
}
