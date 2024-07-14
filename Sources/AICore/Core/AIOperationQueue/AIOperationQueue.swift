//
//  AIOperationQueue.swift
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
        operationQueue.operations
    }

    public var hasOperations: Bool {
        operations.count > 0
    }

    public func addOperation(_ operation: Operation) {
        semaphore.wait()
        operation.completionBlock = {
            self.semaphore.signal()
        }
        operationQueue.addOperation(operation)
    }

    public func addOperation(_ operation: BlockOperation) {
        semaphore.wait()
        operation.completionBlock = {
            self.semaphore.signal()
        }
        operationQueue.addOperation(operation)
    }

    public func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
}

public extension AIOperationQueue {
    static var operationQueue: OperationQueue {
        AIOperationQueue.shared.operationQueue
    }

    static var semaphore: DispatchSemaphore {
        AIOperationQueue.shared.semaphore
    }

    static var operations: [Operation] {
        AIOperationQueue.shared.operations
    }

    static var hasOperations: Bool {
        AIOperationQueue.shared.hasOperations
    }

    class func addOperation(_ operation: Operation) {
        AIOperationQueue.shared.addOperation(operation)
    }

    class func addOperation(_ operation: BlockOperation) {
        AIOperationQueue.shared.addOperation(operation)
    }

    class func cancelAllOperations() {
        AIOperationQueue.shared.cancelAllOperations()
    }
}
