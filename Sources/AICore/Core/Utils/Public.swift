//
//  Public.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import Foundation
import AIEnvironmentKit
import OSLog


public func print(_ items: OSLogMessage..., loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	let stringItems = items.map { "\($0)" }
	print(stringItems, loggerCategory: loggerCategory, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
}

public func print(_ items: String..., loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
	print(items, loggerCategory: loggerCategory, level: level, filename: filename, function: function, line: line, separator: separator, terminator: terminator, sameLine: sameLine)
//#if DEBUG
//#else
//    Swift.print("RELEASE MODE")
//#endif
}

private func print(_ items: [String], loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, filename: String, function : String, line: Int, separator: String, terminator: String, sameLine: Bool?) {
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
			if let loggerCategory = loggerCategory {
				loggerCategory.logger.log(level: level ?? .default, "\(final_print)")
			} else {
				Swift.print(final_print, terminator: terminator)
			}
			
			Utils.logs_updated.send()
		}
	}
}

public func print(_ items: OSLogMessage..., loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
	let stringItems = items.map { "\($0)" }
	print(stringItems, loggerCategory: loggerCategory, level: level, separator: separator, terminator: terminator)
}

public func print(_ items: Any..., loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
	let stringItems = items.map { "\($0)" }
	print(stringItems, loggerCategory: loggerCategory, level: level, separator: separator, terminator: terminator)
}

public func print(_ items: [String], loggerCategory: Logger.Category? = nil, level: OSLogType? = nil, separator: String = " ", terminator: String = "\n") {
	AIEnvironmentKit.executeIfNotAppStore {
		let output = items.map { "\($0)" }.joined(separator: separator)
		if output.isNotEmpty {
			if Config.LOG_PRINTS {
				DispatchQueue.background {
					Utils.writeTextToFile("• \(output)", fileName: Config.log_file_name, folderName: Config.log_folder_name)
					DebugHelper.log(output)
				}
			}
			if let loggerCategory = loggerCategory {
				loggerCategory.logger.log(level: level ?? .default, "\(output)")
			} else {
				Swift.print(output, terminator: terminator)
			}
			Utils.logs_updated.send()
		}
	}
	//#if DEBUG
	//#else
	//    Swift.print("RELEASE MODE")
	//#endif
}
