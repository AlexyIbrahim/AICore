//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 1/23/23.
//

import Foundation

public class AIOperationQueue: NSObject {
    static let shared = AIOperationQueue()
    
    public var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Default queue"
        queue.maxConcurrentOperationCount = 1
        queue.waitUntilAllOperationsAreFinished()
        return queue
    }()
    
    public let semaphore = DispatchSemaphore(value: 0)
    
    public var operations: [Operation] {
        self.operationQueue.operations
    }
    
    public var hasOperations: Bool {
        self.operations.count > 0
    }
    
    public func addOperation(_ operation: Operation) {
        self.semaphore.wait()
        operation.completionBlock = {
            self.semaphore.signal()
        }
        self.operationQueue.addOperation(operation)
    }
    
    public func addOperation(_ operation: BlockOperation) {
        self.semaphore.wait()
        operation.completionBlock = {
            self.semaphore.signal()
        }
        self.operationQueue.addOperation(operation)
    }
    
    public func cancelAllOperations() {
        self.operationQueue.cancelAllOperations()
    }
}

extension AIOperationQueue {
    public static var operationQueue: OperationQueue {
        AIOperationQueue.shared.operationQueue
    }
    
    public static var semaphore: DispatchSemaphore {
        AIOperationQueue.shared.semaphore
    }
    
    public static var operations: [Operation] {
        AIOperationQueue.shared.operations
    }
    
    public static var hasOperations: Bool {
        AIOperationQueue.shared.hasOperations
    }
    
    public class func addOperation(_ operation: Operation) {
        AIOperationQueue.shared.addOperation(operation)
    }
    
    public class func addOperation(_ operation: BlockOperation) {
        AIOperationQueue.shared.addOperation(operation)
    }
    
    public class func cancelAllOperations() {
        AIOperationQueue.shared.cancelAllOperations()
    }
}
    
    
