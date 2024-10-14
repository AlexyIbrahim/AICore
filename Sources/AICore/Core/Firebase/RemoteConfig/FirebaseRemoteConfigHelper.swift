//
//  FirebaseRemoteConfigHelper.swift
//
//
//  Created by Alexy Ibrahim on 1/10/23.
//

import FirebaseRemoteConfig
import Foundation

public class FirebaseRemoteConfigHelper: RawRepresentable, Equatable {
    public var rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static func == (lhs: FirebaseRemoteConfigHelper, rhs: FirebaseRemoteConfigHelper) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static var remoteConfig = RemoteConfig.remoteConfig()
    static let settings = RemoteConfigSettings()

    public class func setup() {
        FirebaseRemoteConfigHelper.settings.minimumFetchInterval = 0
        FirebaseRemoteConfigHelper.remoteConfig.configSettings = FirebaseRemoteConfigHelper.settings
    }

    public class func readDefaults(from: String? = nil) {
        FirebaseRemoteConfigHelper.remoteConfig.setDefaults(fromPlist: from ?? "RemoteConfigDefaults")
    }

    public class func value(forKey key: String, source: RemoteConfigSource? = nil) -> RemoteConfigValue {
        return FirebaseRemoteConfigHelper.remoteConfig.configValue(forKey: key, source: source ?? .default)
    }

    public class func value(forKey key: FirebaseRemoteConfigHelper, source: RemoteConfigSource? = nil) -> RemoteConfigValue {
        return FirebaseRemoteConfigHelper.value(forKey: key.rawValue, source: source)
    }

    public class func fetch() {
        FirebaseRemoteConfigHelper.remoteConfig.fetch { status, error in
            if status == .success {
                self.remoteConfig.activate { _, error in
                    if let error = error {
                        DebugHelper.reportError(error)
                    } else {}
                }
            } else {
                if let error = error {
                    DebugHelper.reportError(error)
                }
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    public class func fetchAndActivate() {
        FirebaseRemoteConfigHelper.remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote {
            } else {
                if let error = error {
                    DebugHelper.reportError(error)
                }
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
