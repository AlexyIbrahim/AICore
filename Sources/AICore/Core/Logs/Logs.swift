//
//  Logs.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import AIEnvironmentKit
import Combine
import Foundation
import OSLog

public struct LogMessage {
    let message: String
    let logLevel: OSLogType
    let filename: String
    let function: String
    let line: Int
}

/// OSLogType
// default: 0
// info: 1
// debug: 2
// error: 16
// fault: 17

public protocol Loggable {
    @available(iOS 14.0, *)
    static var logger: Logger { get }
    static var logLevel: OSLogType { get }
}

public extension Loggable {
    static var logLevel: OSLogType {
        return .default
    }
}

public class LogHelper {
    static let logMessageSubject = PassthroughSubject<LogMessage, Never>()
}

class LogUtils {
    static func shouldLog(logLevel: OSLogType?) -> Bool {
        let logLevel = logLevel ?? .default
        let baseLogLevel = LogConstants.baseLogLevel

        switch baseLogLevel {
        case .info:
            return logLevel == .info || logLevel == .error || logLevel == .fault
        case .debug:
            return logLevel == .debug || logLevel == .info || logLevel == .error || logLevel == .fault
        case .default:
            return true
        default:
            return false
        }
    }

    static func logLevelDescription(logLevel: OSLogType) -> String {
        switch logLevel {
        case .default:
            return "default"
        case .info:
            return "info"
        case .debug:
            return "debug"
        case .error:
            return "error"
        case .fault:
            return "fault"
        default:
            return ""
        }
    }
}

public class LogConstants {
    private static var _baseLogLevel: OSLogType = .default

    public static var baseLogLevel: OSLogType {
        get { return _baseLogLevel }
        set { _baseLogLevel = newValue }
    }

    public static var baseLogLevelDescription: String {
        return LogUtils.logLevelDescription(logLevel: baseLogLevel)
    }

    public static var logPrefix: String = ""
}

// MARK: - Print with file info

// MARK: Loggable

@available(iOS 14, *)
public func print<T: Loggable>(_ caller: T.Type, _ items: OSLogMessage..., level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let logLevel = level ?? caller.logLevel
    print(items, logger: caller.logger, level: logLevel, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

public func print<T: Loggable>(_ caller: T.Type, _ items: String..., level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let logLevel = level ?? caller.logLevel
    if #available(iOS 14.0, *) {
        print(items, logger: caller.logger, level: logLevel, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
    } else {
        print(items, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
    }
}

// MARK: Logger

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger.CategoryEnum? = nil, level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger?.logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: String..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    print(items, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: Any..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: [String], logger: Logger? = nil, level: OSLogType? = nil, filename: String, function: String, line: Int, separator: String, terminator _: String, sameLine: Bool?) {
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\((sameLine ?? true) ? "" : "\n")\t-> "
    let output = items.map { "\(LogConstants.logPrefix)\($0)" }.joined(separator: separator)
    let final_print: String = pretty + output
    if output.isEmpty == false {
        if LogUtils.shouldLog(logLevel: level) {
            if let logger = logger {
                logger.log(level: level ?? .default, "\(final_print)")
            } else if let level = level {
                Logger.misc.log(level: level, "\(final_print)")
            } else {
                Logger.misc.log(level: level ?? .default, "\(final_print)")
            }
        }
        LogHelper.logMessageSubject.send(LogMessage(message: final_print, logLevel: level ?? .default, filename: filename, function: function, line: line))
    }
}

public func print(_ items: [String], level: OSLogType? = nil, filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\((sameLine ?? true) ? "" : "\n")\t-> "
    let output = items.map { "\(LogConstants.logPrefix)\($0)" }.joined(separator: separator)
    let final_print: String = pretty + output
    if output.isEmpty == false {
        if LogUtils.shouldLog(logLevel: level) {
            Swift.print(final_print, terminator: terminator)
        }
        LogHelper.logMessageSubject.send(LogMessage(message: final_print, logLevel: level ?? .default, filename: filename, function: function, line: line))
    }
}

// MARK: - Print without file info

// MARK: Loggable

@available(iOS 14, *)
public func print<T: Loggable>(_ caller: T.Type, _ items: OSLogMessage..., level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let logLevel = level ?? caller.logLevel
    print(items, logger: caller.logger, level: logLevel, separator: separator, terminator: terminator)
}

public func print<T: Loggable>(_ caller: T.Type, _ items: String..., level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let logLevel = level ?? caller.logLevel
    if #available(iOS 14.0, *) {
        print(items, logger: caller.logger, level: logLevel, separator: separator, terminator: terminator)
    } else {
        Swift.print(items.map { "\(LogConstants.logPrefix)\($0)" }, separator: separator, terminator: terminator)
        LogHelper.logMessageSubject.send(LogMessage(message: items.joined(separator: separator), logLevel: logLevel, filename: "", function: "", line: 0))
    }
}

// MARK: Logger

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger.CategoryEnum? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger?.logger, level: level, separator: separator, terminator: terminator)
}

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger, level: level, separator: separator, terminator: terminator)
}

@available(iOS 14, *)
public func print(_ items: String..., logger: Logger? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    print(items, logger: logger, level: level, separator: separator, terminator: terminator)
}

@available(iOS 14, *)
public func print(_ items: Any..., logger: Logger? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let stringItems = items.map { "\($0)" }
    print(stringItems, logger: logger, level: level, separator: separator, terminator: terminator)
}

@available(iOS 14, *)
public func print(_ items: [String], logger: Logger? = nil, level: OSLogType? = nil, separator: String = " ", terminator _: String = "\n") {
    let output = items.map { "\(LogConstants.logPrefix)\($0)" }.joined(separator: separator)
    if output.isEmpty == false {
        if LogUtils.shouldLog(logLevel: level) {
            if let logger = logger {
                logger.log(level: level ?? .default, "\(output)")
            } else if let level = level {
                Logger.misc.log(level: level, "\(output)")
            } else {
                Logger.misc.log(level: level ?? .default, "\(output)")
            }
        }
        LogHelper.logMessageSubject.send(LogMessage(message: output, logLevel: level ?? .default, filename: "", function: "", line: 0))
    }
}

public func print(_ items: [String], level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
    let output = items.map { "\(LogConstants.logPrefix)\($0)" }.joined(separator: separator)
    if output.isEmpty == false {
        if LogUtils.shouldLog(logLevel: level) {
            Swift.print(output, terminator: terminator)
        }
        LogHelper.logMessageSubject.send(LogMessage(message: output, logLevel: level ?? .default, filename: "", function: "", line: 0))
    }
}
