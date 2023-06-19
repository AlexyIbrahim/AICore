//
//  ArrayExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 11/25/22.
//

import Foundation
import Combine

public extension Array {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

public extension Array where Element == AnyCancellable {
    mutating func removeAll() {
        self.forEach { value in
            value.cancel()
        }
        self.removeAll(keepingCapacity: false)
    }
}
