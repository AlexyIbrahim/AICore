import Foundation

@propertyWrapper
internal class Announced<Value> {
	private class CallbackWrapper {
		let callback: (Value) -> Void

		init(callback: @escaping (Value) -> Void) {
			self.callback = callback
		}
	}

	private var value: Value
	private var callbacks: [CallbackWrapper] = []
	private let queue = DispatchQueue(label: "com.announced", attributes: .concurrent)
	private var debounceWorkItem: DispatchWorkItem?
	private var debounceDelay: DispatchTimeInterval?

	var wrappedValue: Value {
		get {
			return value
		}
		set {
			self.value = newValue
			self.notifySubscribersDebounced()
//			queue.async(flags: .barrier) {
//				self.value = newValue
//				self.notifySubscribersDebounced()
//			}
		}
	}

	init(wrappedValue: Value) {
		self.value = wrappedValue
	}

	private func notifySubscribers() {
		for wrapper in callbacks {
			wrapper.callback(value)
		}
	}

	private func notifySubscribersDebounced() {
		debounceWorkItem?.cancel()
		let workItem = DispatchWorkItem { [weak self] in
			self?.notifySubscribers()
		}
		debounceWorkItem = workItem
		if let delay = debounceDelay {
			DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
		} else {
			workItem.perform()
		}
	}

	var projectedValue: Announced<Value> {
		return self
	}

	func subscribe(on queue: DispatchQueue = .main, _ callback: @escaping (Value) -> Void) -> HotlineCancellable {
		let wrapper = CallbackWrapper(callback: { value in
			queue.async(flags: .barrier) {
				callback(value)
			}
		})
		self.queue.async(flags: .barrier) {
			wrapper.callback(self.value)
			self.callbacks.append(wrapper)
		}
		return HotlineSubscription { [weak self] in
			guard let self = self else { return }
			self.unsubscribe(wrapper)
		}
	}

	private func unsubscribe(_ wrapper: CallbackWrapper) {
		self.queue.async(flags: .barrier) {
			if let index = self.callbacks.firstIndex(where: { $0 === wrapper }) {
				self.callbacks.remove(at: index)
			}
		}
	}

	func debounce(for delay: DispatchTimeInterval) -> Announced<Value> {
		debounceDelay = delay
		return self
	}
}
