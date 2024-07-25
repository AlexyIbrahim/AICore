import Foundation

protocol HotlineCancellable {
	func cancel()
	func store(in array: inout [HotlineCancellable])
	func store(in set: inout Set<HotlineSubscription>)
}

extension HotlineCancellable {
	func store(in array: inout [HotlineCancellable]) {
		array.append(self)
	}

	func store(in set: inout Set<HotlineSubscription>) {
		set.insert(self as! HotlineSubscription)
	}
}

class HotlineSubscription: HotlineCancellable, Hashable {
	private let cancelCallback: () -> Void

	init(cancel: @escaping () -> Void) {
		self.cancelCallback = cancel
	}

	func cancel() {
		cancelCallback()
	}

	static func == (lhs: HotlineSubscription, rhs: HotlineSubscription) -> Bool {
		return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
}
