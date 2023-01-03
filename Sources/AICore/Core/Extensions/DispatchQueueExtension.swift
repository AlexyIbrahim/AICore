//
//  DispatchQueueExtension.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/20/22.
//

import Foundation

public extension DispatchQueue {

    static func background(background: (()->Void)? = nil, completionOnMain: (() -> Void)? = nil, completionDelay delay: Double? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completionOnMain {
                DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
                    completion()
                })
            }
        }
    }
    
    static func main(_ code: (() -> Void)? = nil, delay: Double? = nil) {
        if let code = code {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
                code()
            })
        }
    }

}
