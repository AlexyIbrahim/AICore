//
//  Public.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/11/22.
//

import Foundation

public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n", sameLine: Bool? = nil) {
#if DEBUG
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\((sameLine ?? true) ? "" : "\n")\t-> "
    let output = items.map { "\($0)" }.joined(separator: separator)
    let final_print: String = pretty+output
    if Config.LOG_PRINTS {
        Utils.logTextToFile(final_print, fileName: Config.log_file_name, folderName: Config.log_folder_name)
        DebugHelper.log(final_print)
    }
    Swift.print(final_print, terminator: terminator)
    Utils.logs_updated.send()
#else
    Swift.print("RELEASE MODE")
#endif
}

public func print(_ items: Any...,  separator: String = " ", terminator: String = "\n") {
#if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    if Config.LOG_PRINTS {
        Utils.logTextToFile(output, fileName: Config.log_file_name, folderName: Config.log_folder_name)
        DebugHelper.log(output)
    }
    Swift.print(output, terminator: terminator)
    Utils.logs_updated.send()
#else
    Swift.print("RELEASE MODE")
#endif
}
