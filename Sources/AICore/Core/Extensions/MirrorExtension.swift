//
//  MirrorExtension.swift
//
//
//  Created by Alexy Ibrahim on 2/2/23.
//

import Foundation

public extension Mirror { // where DisplayStyle == .struct
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for child in children {
            if let label = child.label {
                dictionary[label] = child.value
            }
        }
        return dictionary
    }
}
