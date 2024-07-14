//
//  DateExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/7/22.
//

import Foundation

public enum DateFormatEnum {
    case MMMMddyyyy
    case ddMMMMyyyyhhmm

    var format: String {
        switch self {
        case .MMMMddyyyy:
            return "MMMM dd, yyyy"
        case .ddMMMMyyyyhhmm:
            return "dd MMMM yyyy, hh:mm"
        default:
            return "MMMM dd, yyyy"
        }
    }
}

public extension Date {
    var millisecondsSince1970: Int {
        Int((timeIntervalSince1970 * 1000.0).rounded())
    }

    static var millisecondsSince1970: Int {
        Int((Date.timeIntervalBetween1970AndReferenceDate * 1000.0).rounded())
    }

    func formatted(_ format: DateFormatEnum) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format.format
        return dateformat.string(from: self)
    }

    static func fromMillisecondsTimestamp(_ timestamp: Int) -> Date {
        return fromMillisecondsTimestamp(Double(timestamp))
    }

    static func fromMillisecondsTimestamp(_ timestamp: Double) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        return date
    }
}
