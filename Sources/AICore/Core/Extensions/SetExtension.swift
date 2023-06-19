//
//  SetExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/20/22.
//

import Foundation
import Combine


public extension Set {
    var array: [Element] {
        return Array(self)
    }
}


public extension Set where Element == AnyCancellable {
    mutating func removeAll() {
        self.forEach { value in
            value.cancel()
        }
        self.removeAll(keepingCapacity: false)
    }
}
