//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 2/2/23.
//

import Foundation

enum MyError: Error {
    case error(String)
}

public extension Error {
    static func custom(_ description: String) -> Error {
        return MyError.error(description)
    }
}
