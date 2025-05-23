
import AIEnvironmentKit
import AINetworkCalls
import UIKit

@objcMembers public class Config: NSObject {
    public static var environment: Environment = {
        let envString = (Utils.readFromPropertyList("Config", key: "ENVIRONMENT") as! String)
        let env = Environment(rawValue: envString)
        return setEnvironment(env)
    }()
}

public extension Config {}

// MARK: - env

public extension Config {
    struct Environment: RawRepresentable, Equatable {
        public var rawValue: String
//        public typealias RawValue = String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static func == (lhs: Environment, rhs: Environment) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }

        public static let dev = Environment(rawValue: "development")
        public static let prod = Environment(rawValue: "production")

        var displayName: String {
            switch self {
            case .dev:
                return "development"
            case .prod:
                return "production"
            default:
                return ""
            }
        }

        var configKeyName: String {
            switch self {
            case .dev:
                return "development"
            case .prod:
                return "production"
            default:
                return ""
            }
        }
    }

    static func setEnvironment(_ env: Environment) -> Environment {
        if AIEnvironmentKit.isAppStore { // to protect app store builds in case this wasn't updated
            return .prod
        } else {
            return env
        }
    }

    @objc static var isDevelopment: Bool {
        switch Config.environment {
        case .dev:
            return true
        default:
            return false
        }
    }

    @objc static var isProduction: Bool {
        switch Config.environment {
        case .prod:
            return true
        default:
            return false
        }
    }

    static var environmentDisplayName: String {
        Config.environment.displayName
    }

    static var environmentConfigKeyName: String {
        Config.environment.rawValue
    }

    static var log_file_name: String!
    static var log_folder_name: String?
}

// MARK: - settings | keys

public extension Config {
    // MARK: API Endpoint

    static var API_ENDPOINT: String {
        return Utils.readDynamicConfigFromPropertyListForKey("API_ENDPOINT", subKey: Config.environmentConfigKeyName)!
    }

    static var LOG_PRINTS: Bool {
        return Utils.readDynamicConfigFromPropertyListForKey("LOG_PRINTS") ?? false
    }
}
