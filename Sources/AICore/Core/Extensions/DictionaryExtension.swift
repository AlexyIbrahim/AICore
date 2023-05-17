//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 5/17/23.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
    func toStringValues() -> [String: String] {
        var convertedDict: [String: String] = [:]
        
        for (key, value) in self {
            if let stringValue = value as? String {
                convertedDict[key] = stringValue
            } else {
                convertedDict[key] = String(describing: value)
            }
        }
        
        return convertedDict
    }
}
