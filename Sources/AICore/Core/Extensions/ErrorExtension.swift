//
//  ErrorExtension.swift
//
//
//  Created by Alexy Ibrahim on 2/2/23.
//

import Foundation

// public enum AIError: Error {
//    case error(String)
// }

public struct AIError: LocalizedError {
    public var errorDescription: String?

    public init(_ description: String) {
        errorDescription = description
    }
}
