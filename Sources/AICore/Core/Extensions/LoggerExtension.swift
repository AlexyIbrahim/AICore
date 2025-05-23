//
//  LoggerExtension.swift
//
//
//  Created by Alexy Ibrahim on 9/20/23.
//

import Foundation
import OSLog

@available(iOS 14.0, *)
public extension Logger {
    static let viewCycle: Logger = Logger.Category.viewCycle.logger
    static let networking: Logger = Logger.Category.networking.logger
    static let statistics: Logger = Logger.Category.statistics.logger
    static let system: Logger = Logger.Category.system.logger
    static let misc: Logger = Logger.Category.misc.logger

    private struct Category {
        public let logger: Logger

        public static let viewCycle = Logger.Category(logger: Logger(subsystem: Constants.bundleId, category: "viewcycle"))
        public static let networking = Logger.Category(logger: Logger(subsystem: Constants.bundleId, category: "networking"))
        public static let statistics = Logger.Category(logger: Logger(subsystem: Constants.bundleId, category: "statistics"))
        public static let system = Logger.Category(logger: Logger(subsystem: Constants.bundleId, category: "system"))
        public static let misc = Logger.Category(logger: Logger(subsystem: Constants.bundleId, category: "misc"))
    }

    enum CategoryEnum {
        case custom(_ category: String)

        var logger: Logger {
            switch self {
            case let .custom(category):
                return Logger(subsystem: Constants.bundleId, category: category)
            }
        }
    }
}
