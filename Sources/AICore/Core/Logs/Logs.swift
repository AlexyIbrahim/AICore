//
//  Logs.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import Foundation
import AIEnvironmentKit
import OSLog

public enum LogLevelEnum {
	case verbose
	case debug
	case info
	case warning
	case error
}

extension LogLevelEnum {
	var osLogType: OSLogType {
		switch self {
		case .verbose:
			return .debug
		case .debug:
			return .debug
		case .info:
			return .info
		case .warning:
			return .default
		case .error:
			return .error
		}
	}
}

@available(iOS 14, *)
public protocol Loggable {
	static var logger: Logger { get }
	static var logLevel: LogLevelEnum { get }
}

@available(iOS 14, *)
extension Loggable {
	static var logLevel: LogLevelEnum {
		return .verbose
	}
}

// MARK: - Print with file info
@available(iOS 14, *)
public func print<T: Loggable>(_ caller: T.Type, _ items: OSLogMessage..., level: LogLevelEnum? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let logLevel = level ?? caller.logLevel
	if (logLevel == .error) || (logLevel == .warning) || (logLevel.osLogType.rawValue >= caller.logLevel.osLogType.rawValue) {
		print(items, logger: caller.logger, level: logLevel.osLogType, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
	}
}

@available(iOS 14, *)
internal func print<T: Loggable>(_ caller: T.Type, _ items: String..., level: LogLevelEnum? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let logLevel = level ?? caller.logLevel
	if (logLevel == .error) || (logLevel == .warning) || (logLevel.osLogType.rawValue >= caller.logLevel.osLogType.rawValue) {
		print(items, logger: caller.logger, level: logLevel.osLogType, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
	}
}

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger.CategoryEnum? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let stringItems = items.map { "\($0)" }
	print(stringItems, logger: logger?.logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: OSLogMessage..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let stringItems = items.map { "\($0)" }
	print(stringItems, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: String..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	print(items, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
public func print(_ items: Any..., logger: Logger? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let stringItems = items.map { "\($0)" }
	print(stringItems, logger: logger, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

@available(iOS 14, *)
private func print(_ items: [String], logger: Logger? = nil, level: OSLogType? = nil, filename: String, function : String, line: Int, separator: String, terminator: String, sameLine: Bool?) {
	AIEnvironmentKit.executeIfNotAppStore {
		let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\((sameLine ?? true) ? "" : "\n")\t-> "
		let output = items.map { "\($0)" }.joined(separator: separator)
		if output.isNotEmpty {
			let final_print: String = pretty+output
			if Config.LOG_PRINTS {
				DispatchQueue.background {
					Utils.writeTextToFile("• \(final_print)", fileName: Config.log_file_name, folderName: Config.log_folder_name)
					DebugHelper.log(final_print)
				}
			}
			if let logger = logger {
				logger.log(level: level ?? .default, "\(final_print)")
			} else if let level = level {
				Logger.misc.log(level: level, "\(final_print)")
			} else {
				if #available(iOS 14, *) {
					Logger.misc.log(level: level ?? .default, "\(final_print)")
				} else {
					Swift.print(final_print, terminator: terminator)
				}
			}
			
			Utils.logs_updated.send()
		}
	}
}

// MARK: - Print without file info
@available(iOS 14, *)
public func print<T: Loggable>(_ caller: T.Type, _ items: OSLogMessage..., level: LogLevelEnum? = nil, separator: String = " ", terminator: String = "\n") {
	let logLevel = level ?? caller.logLevel
	if (logLevel == .error) || (logLevel == .warning) || (logLevel.osLogType.rawValue >= caller.logLevel.osLogType.rawValue) {
		print(items, logger: caller.logger, level: logLevel.osLogType, separator: separator, terminator: terminator)
	}
}

@available(iOS 14, *)
internal func print<T: Loggable>(_ caller: T.Type, _ items: String..., level: LogLevelEnum? = nil, separator: String = " ", terminator: String = "\n") {
	let logLevel = level ?? caller.logLevel
	if (logLevel == .error) || (logLevel == .warning) || (logLevel.osLogType.rawValue >= caller.logLevel.osLogType.rawValue) {
		print(items, logger: caller.logger, level: logLevel.osLogType, separator: separator, terminator: terminator)
	}
}

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
public func print(_ items: [String], logger: Logger? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
	AIEnvironmentKit.executeIfNotAppStore {
		let output = items.map { "\($0)" }.joined(separator: separator)
		if output.isNotEmpty {
			if Config.LOG_PRINTS {
				DispatchQueue.background {
					Utils.writeTextToFile("• \(output)", fileName: Config.log_file_name, folderName: Config.log_folder_name)
					DebugHelper.log(output)
				}
			}
			if let logger = logger {
				logger.log(level: level ?? .default, "\(output)")
			} else if let level = level {
				Logger.misc.log(level: level, "\(output)")
			} else {
				if #available(iOS 14, *) {
					Logger.misc.log(level: level ?? .default, "\(output)")
				} else {
					Swift.print(output, terminator: terminator)
				}
			}
			Utils.logs_updated.send()
		}
	}
	//#if DEBUG
	//#else
	//    Swift.print("RELEASE MODE")
	//#endif
}
