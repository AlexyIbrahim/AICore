//
//  DispatchQueueExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/20/22.
//

import Foundation

public extension DispatchQueue {

    static func background(background: (()->Void)? = nil, delay: Double? = nil, completionOnMain: (() -> Void)? = nil, completionDelay: Double? = nil) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
            background?()
            if let completion = completionOnMain {
                DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
                    completion()
                })
            }
        })
    }
    
    static func main(_ code: (() -> Void)? = nil, delay: Double? = nil) {
        if let code = code {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
                code()
            })
        }
    }

}
