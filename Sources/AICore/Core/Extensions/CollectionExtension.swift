//
//  CollectionExtension.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/17/22.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    func toOptional() -> Wrapped?
}

extension Optional : OptionalType {
    public func toOptional() -> Wrapped? {
        return self
    }
}

public extension Dictionary where Value: OptionalType {
    func unwrappedValues() -> [Key: Value.Wrapped] {
        return filter({ $0.value.toOptional() != nil })
           .mapValues({ $0.toOptional()! })
    }
}
