import Foundation

public extension DispatchQueue {
	/// Function to run code in the background thread.
	/// Optionally, you can specify a delay and a completion block to run on the main thread after the background code is done executing.
	/// - Parameters:
	///   - delay: The time in seconds before the background code should start. Default is nil, which means it starts immediately.
	///   - completionDelay: The time in seconds before the completion code should start. Default is nil, which means it starts immediately after the background code is done.
	///   - isSynchronous: Whether the execution should be synchronous. Default is false.
	///   - background: The code to run in the background.
	///   - completionOnMain: The code to run on the main thread after the background code is done. Default is nil, which means nothing is run afterwards.
	static func background(delay: DispatchTimeInterval? = nil, completionDelay: Double? = nil, isSynchronous: Bool = false, background: @escaping (() -> Void), completionOnMain: (() -> Void)? = nil) {
		let executeBlock = {
			if isSynchronous {
				DispatchQueue.global(qos: .background).sync {
					background()
					if let completion = completionOnMain {
						if Thread.isMainThread {
							completion()
						} else {
							DispatchQueue.main.sync {
								completion()
							}
						}
					}
				}
			} else {
				DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (delay ?? .seconds(0)), execute: {
					background()
					if let completion = completionOnMain {
						DispatchQueue.main.asyncAfter(deadline: .now() + (completionDelay ?? 0), execute: {
							completion()
						})
					}
				})
			}
		}
		
		if isSynchronous {
			executeBlock()
		} else {
			DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (delay ?? .seconds(0)), execute: executeBlock)
		}
	}
	
	/// Function to run code on the main thread.
	/// Optionally, you can specify a delay before the code should start executing.
	/// - Parameters:
	///   - code: The code to run on the main thread.
	///   - delay: The time in seconds before the code should start. Default is nil, which means it starts immediately.
	///   - isSynchronous: Whether the execution should be synchronous. Default is false.
	static func main(delay: DispatchTimeInterval? = nil, isSynchronous: Bool = false, _ code: @escaping (() -> Void)) {
		if isSynchronous {
			if Thread.isMainThread {
				code()
			} else {
				DispatchQueue.main.sync {
					code()
				}
			}
		} else {
			DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? .seconds(0)), execute: {
				code()
			})
		}
	}
}

/// Function to run code on the main thread.
/// Optionally, you can specify a delay before the code should start executing.
/// - Parameters:
///   - code: The code to run on the main thread.
///   - delay: The time in seconds before the code should start. Default is nil, which means it starts immediately.
///   - isSynchronous: Whether the execution should be synchronous. Default is false.
public func mainThread(delay: DispatchTimeInterval? = nil, isSynchronous: Bool = false, _ code: @escaping (() -> Void)) {
	DispatchQueue.main(delay: delay, isSynchronous: isSynchronous, code)
}

/// Function to run code in the background thread.
/// Optionally, you can specify a delay and a completion block to run on the main thread after the background code is done executing.
/// - Parameters:
///   - background: The code to run in the background.
///   - delay: The time in seconds before the background code should start. Default is nil, which means it starts immediately.
///   - completionOnMain: The code to run on the main thread after the background code is done. Default is nil, which means nothing is run afterwards.
///   - completionDelay: The time in seconds before the completion code should start. Default is nil, which means it starts immediately after the background code is done.
///   - isSynchronous: Whether the execution should be synchronous. Default is false.
public func backgroundThread(delay: DispatchTimeInterval? = nil, completionDelay: Double? = nil, isSynchronous: Bool = false, background: @escaping (() -> Void), completionOnMain: (() -> Void)? = nil) {
	DispatchQueue.background(delay: delay, completionDelay: completionDelay, isSynchronous: isSynchronous, background: background, completionOnMain: completionOnMain)
}
