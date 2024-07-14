//
//  EncodableExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 9/14/22.
//

import Foundation

public extension Encodable {
    func asDictionary<T>() -> [String: T] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: T] else { return [:] }

        return dictionary
    }

    func asDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [:] }

        return dictionary
    }

    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

    func asJsonString() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        guard let json = try? encoder.encode(self) else { return nil }
        return String(data: json, encoding: .utf8)
    }
}
