//
//  FirebasePerformanceHelper.swift
//
//
//  Created by Alexy Ibrahim on 1/9/23.
//

import FirebasePerformance
import Foundation

public class FirebasePerformanceHelper {
    static let shared = FirebasePerformanceHelper()

    public class func startTrace(_ traceName: String, metrics: [String: Int64]? = nil, attributes: [String: String]? = nil) -> FirebasePerformance.Trace? {
        let trace = Performance.startTrace(name: traceName)
        metrics?.forEach { (key: String, value: Int64) in
            trace?.setValue(value, forMetric: key)
        }
        attributes?.forEach { (key: String, value: String) in
            trace?.setValue(value, forAttribute: key)
        }
        return trace
    }

    public class func stopTrace(trace: FirebasePerformance.Trace?) {
        guard let trace = trace else { return }
        trace.stop()
    }

    public class func incrementMetric(forTrace trace: FirebasePerformance.Trace?, metric: String, by: Int64? = nil) {
        guard let trace = trace else { return }
        trace.incrementMetric(metric, by: by ?? 1)
    }

    public class func valueForMetric(forTrace trace: FirebasePerformance.Trace?, metric: String) -> Int64? {
        guard let trace = trace else { return nil }
        return trace.valueForMetric(metric)
    }

    public class func valueForAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String) -> String? {
        guard let trace = trace else { return nil }
        return trace.value(forAttribute: attribute)
    }

    public class func removeAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String) {
        guard let trace = trace else { return }
        trace.removeAttribute(attribute)
    }

    public class func attributes(forTrace trace: FirebasePerformance.Trace?) -> [String: String]? {
        guard let trace = trace else { return nil }
        return trace.attributes
    }

    public class func setMetric(forTrace trace: FirebasePerformance.Trace?, metric: String, value: Int64) {
        guard let trace = trace else { return }
        trace.setValue(value, forMetric: metric)
    }

    public class func setAttribute(forTrace trace: FirebasePerformance.Trace?, attribute: String, value: String) {
        guard let trace = trace else { return }
        trace.setValue(value, forAttribute: attribute)
    }
}
