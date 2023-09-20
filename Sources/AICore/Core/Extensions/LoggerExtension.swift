//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 9/20/23.
//

import Foundation
import OSLog

public extension Logger {
	static let viewCycle = Logger(subsystem: Constants.bundleId, category: "viewcycle")
	static let statistics = Logger(subsystem: Constants.bundleId, category: "statistics")
	static let system = Logger(subsystem: Constants.bundleId, category: "system")
	static let misc = Logger(subsystem: Constants.bundleId, category: "misc")
}
