//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 2/2/23.
//

import Foundation

public extension Mirror { // where DisplayStyle == .struct
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        children.forEach {
            if let label = $0.label {
                dictionary[label] = $0.value
            }
        }
        return dictionary
    }
}
