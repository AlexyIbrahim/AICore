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
    
    public class func startTrace(_ traceName: String, metrics: [String: Int64]? = nil, attributes: [String: String]? = nil) -> FirebasePerformance.Trace? {
        let trace = Performance.startTrace(name: traceName)
        metrics?.forEach({ (key: String, value: Int64) in
            trace?.setValue(value, forMetric: key)
        })
        attributes?.forEach({ (key: String, value: String) in
            trace?.setValue(value, forAttribute: key)
        })
        return trace
    }
    
    public class func stopTrace(trace: FirebasePerformance.Trace?) {
        trace?.stop()
    }
    
    public class func incrementMetric(forTrace trace: FirebasePerformance.Trace?, metric: String, by: Int64? = nil) {
        trace?.incrementMetric(metric, by: by ?? 1)
    }
    
    public class func valueForMetric(forTrace trace: FirebasePerformance.Trace?, metric: String) -> Int64? {
        trace?.valueForMetric(metric)
    }
    
    public class func valueForAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String) -> String? {
        trace?.value(forAttribute: attribute)
    }
    
    public class func removeAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String) {
        trace?.removeAttribute(attribute)
    }
    
    public class func attributes(forTrace trace: FirebasePerformance.Trace?) -> [String: String]? {
        trace?.attributes
    }
    
    public class func setMetric(forTrace trace: FirebasePerformance.Trace?, metric: String, value: Int64) {
        trace?.setValue(value, forMetric: metric)
    }
    
    public class func setAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String, value: String) {
        trace?.setValue(value, forAttribute: attribute)
    }
}
