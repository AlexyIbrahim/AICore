//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 2/2/23.
//

import Foundation

//public enum AIError: Error {
//    case error(String)
//}

struct AIError: Error {
    var errorDescription: String?

    init(_ description: String) {
        self.errorDescription = description
    }
}
