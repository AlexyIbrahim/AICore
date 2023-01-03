//
//  TimeZoneExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/20/22.
//

import Foundation


public extension TimeZone {
    func offsetFromUTC() -> String {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetFromGMTInHours() -> String {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
    
    static func offsetFromGMTInHours() -> Int {
        let seconds = TimeZone.current.secondsFromGMT()
        
        let hours = seconds/3600
        return hours
    }
    
    static func offsetFromGMTInMinutes() -> Int {
        let seconds = TimeZone.current.secondsFromGMT()
        
        let minutes = abs(seconds/60) % 60
        return minutes
    }
}
