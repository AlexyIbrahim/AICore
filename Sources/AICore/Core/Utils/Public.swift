//
//  Public.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import Foundation
import AIEnvironmentKit

public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
    AIEnvironmentKit.executeIfNotAppStore {
        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\((sameLine ?? true) ? "" : "\n")\t-> "
        let output: String = items.map { "\($0)" }.joined(separator: separator)
        if output.isNotEmpty {
            if Config.LOG_PRINTS {
                Utils.writeTextToFile("• \(final_print)", fileName: Config.log_file_name, folderName: Config.log_folder_name)
                DebugHelper.log(final_print)
            }
            Swift.print(final_print, terminator: terminator)
            Utils.logs_updated.send()
        }
    }
//#if DEBUG
//#else
//    Swift.print("RELEASE MODE")
//#endif
}

public func print(_ items: Any...,  separator: String = " ", terminator: String = "\n") {
    AIEnvironmentKit.executeIfNotAppStore {
        let output = items.map { "\($0)" }.joined(separator: separator)
        if output.isNotEmpty {
            if Config.LOG_PRINTS {
                Utils.writeTextToFile("• \(output)", fileName: Config.log_file_name, folderName: Config.log_folder_name)
                DebugHelper.log(output)
            }
            Swift.print(output, terminator: terminator)
            Utils.logs_updated.send()
        }
    }
//#if DEBUG
//#else
//    Swift.print("RELEASE MODE")
//#endif
}
