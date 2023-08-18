import Foundation

public extension DispatchQueue {
	
	/// Function to run code in the background thread.
	/// Optionally, you can specify a delay and a completion block to run on the main thread after the background code is done executing.
	/// - Parameters:
	///   - background: The code to run in the background.
	///   - delay: The time in seconds before the background code should start. Default is nil, which means it starts immediately.
	///   - completionOnMain: The code to run on the main thread after the background code is done. Default is nil, which means nothing is run afterwards.
	///   - completionDelay: The time in seconds before the completion code should start. Default is nil, which means it starts immediately after the background code is done.
	static func background(background: @escaping (() -> Void), delay: Double? = nil, completionOnMain: (() -> Void)? = nil, completionDelay: Double? = nil) {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
			background()
			if let completion = completionOnMain {
				DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
					completion()
				})
			}
		})
	}
	
	/// Function to run code on the main thread.
	/// Optionally, you can specify a delay before the code should start executing.
	/// - Parameters:
	///   - code: The code to run on the main thread.
	///   - delay: The time in seconds before the code should start. Default is nil, which means it starts immediately.
	static func main(_ code: @escaping (() -> Void), delay: Double? = nil) {
		DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0.0), execute: {
			code()
		})
	}
}

/// Function to run code on the main thread.
/// Optionally, you can specify a delay before the code should start executing.
/// - Parameters:
///   - code: The code to run on the main thread.
///   - delay: The time in seconds before the code should start. Default is nil, which means it starts immediately.
func mainThread(_ code: @escaping (() -> Void), delay: Double? = nil) {
	DispatchQueue.main(code, delay: delay)
}

/// Function to run code in the background thread.
/// Optionally, you can specify a delay and a completion block to run on the main thread after the background code is done executing.
/// - Parameters:
///   - background: The code to run in the background.
///   - delay: The time in seconds before the background code should start. Default is nil, which means it starts immediately.
///   - completionOnMain: The code to run on the main thread after the background code is done. Default is nil, which means nothing is run afterwards.
///   - completionDelay: The time in seconds before the completion code should start. Default is nil, which means it starts immediately after the background code is done.
func backgroundThread(background: @escaping (() -> Void), delay: Double? = nil, completionOnMain: (() -> Void)? = nil, completionDelay: Double? = nil) {
	DispatchQueue.background(background: background, delay: delay, completionOnMain: completionOnMain, completionDelay: completionDelay)
}
