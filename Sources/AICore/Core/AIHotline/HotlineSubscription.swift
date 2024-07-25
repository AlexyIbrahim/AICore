import Foundation

public protocol HotlineCancellable {
	func cancel()
	func store(in array: inout [HotlineCancellable])
	func store(in set: inout Set<HotlineSubscription>)
}

public extension HotlineCancellable {
	func store(in array: inout [HotlineCancellable]) {
		array.append(self)
	}

	func store(in set: inout Set<HotlineSubscription>) {
		set.insert(self as! HotlineSubscription)
	}
}

public class HotlineSubscription: HotlineCancellable, Hashable {
	private let cancelCallback: () -> Void

	public init(cancel: @escaping () -> Void) {
		self.cancelCallback = cancel
	}

	public func cancel() {
		cancelCallback()
	}

	public static func == (lhs: HotlineSubscription, rhs: HotlineSubscription) -> Bool {
		return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
}
