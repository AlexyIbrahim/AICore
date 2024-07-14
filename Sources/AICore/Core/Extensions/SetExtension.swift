//
//  SetExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/20/22.
//

import Combine
import Foundation

public extension Set {
    var array: [Element] {
        return Array(self)
    }
}

public extension Set where Element == AnyCancellable {
    mutating func removeAll() {
        for value in self {
            value.cancel()
        }
        removeAll(keepingCapacity: false)
    }
}
