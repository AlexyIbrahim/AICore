//
//  ArrayExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 11/25/22.
//

import Combine
import Foundation

public extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

public extension Array where Element == AnyCancellable {
    mutating func removeAll() {
        for value in self {
            value.cancel()
        }
        removeAll(keepingCapacity: false)
    }
}
