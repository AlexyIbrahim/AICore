//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 1/9/23.
//

import Foundation
import FirebasePerformance

public class FirebasePerformanceHelper {
    static let shared = FirebasePerformanceHelper()
    
    class func trace(_ traceName: String, metrics: [String: Int64]? = nil, attributes: [String: String]? = nil) -> FirebasePerformance.Trace? {
        let trace = Performance.startTrace(name: traceName)
        metrics?.forEach({ (key: String, value: Int64) in
            trace?.setValue(value, forMetric: key)
        })
        attributes?.forEach({ (key: String, value: String) in
            trace?.setValue(value, forAttribute: key)
        })
        return trace
    }
    
    class func incrementMetric(forTrace trace: FirebasePerformance.Trace, metric: String, by: Int64? = nil) {
        trace.incrementMetric(metric, by: by ?? 1)
    }
}
