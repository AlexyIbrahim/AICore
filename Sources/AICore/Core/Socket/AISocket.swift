import Combine
import Foundation
import OSLog
import Starscream
import SwiftyJSON

typealias AISocketDefaultResponseType = Any
typealias AISocketEventCallback = (AISocketDefaultResponseType) -> Void

public class AISocket: Loggable {
    static var shared = AISocket()

    @available(iOS 14.0, *)
    public static var logger: Logger = .init(subsystem: Constants.bundleId, category: "Socket")
    public static var logLevel: OSLogType = .info

    private(set) var socket: WebSocket!
    private var eventCallbacks: [String: AISocketEventCallback] = [:]

    private(set) var isConnected: Bool = false {
        didSet {
            isConnectedCombine.send(isConnected)
        }
    }

    private(set) var isConnectedCombine = CurrentValueSubject<Bool, Never>(false)
    private(set) var onConnect = PassthroughSubject<[String: String], Never>()
    private(set) var onDisconnect = PassthroughSubject<(data: String, value: UInt16), Never>()
    private(set) var onText = PassthroughSubject<String, Never>()
    private(set) var onBinary = PassthroughSubject<Data, Never>()
    private(set) var onPing = PassthroughSubject<Data?, Never>()
    private(set) var onPong = PassthroughSubject<Data?, Never>()
    private(set) var onError = PassthroughSubject<Error?, Never>()
    private(set) var onViabilityChanged = PassthroughSubject<Bool, Never>()
    private(set) var onReconnectSuggested = PassthroughSubject<Bool, Never>()
    private(set) var onCancelled = PassthroughSubject<Void, Never>()
    private(set) var onPeerClosed = PassthroughSubject<Void, Never>()

    init() {}

    init(urlString: String, extraHeaders: [String: String]? = nil) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 5

        if let extraHeaders = extraHeaders {
            request.allHTTPHeaderFields = extraHeaders
        }

        socket = WebSocket(request: request)
        socket.delegate = self
        //		self.initializeRequiredListeners()
    }

    init(host: String, port: Int? = nil, extraHeaders: [String: String]? = nil) {
        var urlString = ""
        if let port = port {
            urlString = "\(host):\(port)"
        } else {
            urlString = "\(host)"
        }

        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 5

        if let extraHeaders = extraHeaders {
            request.allHTTPHeaderFields = extraHeaders
        }

        socket = WebSocket(request: request)
        socket.delegate = self
        //		self.initializeRequiredListeners()
    }

    final class func initShared(urlString: String, extraHeaders: [String: String]? = nil) {
        AISocket.shared = AISocket(urlString: urlString, extraHeaders: extraHeaders)
    }

    func initializeRequiredListeners() {
        socket.onEvent = { event in
            self.handleEvent(event: event)
        }
    }
}

extension AISocket: WebSocketDelegate {
    public func didReceive(event: Starscream.WebSocketEvent, client _: Starscream.WebSocketClient) {
        handleEvent(event: event)
    }
}

extension AISocket {
    func handleEvent(event: Starscream.WebSocketEvent) {
        switch event {
        case let .connected(data):
            print(AISocket.self, "connected data: \(data)")
            isConnected = true
            onConnect.send(data)
        case let .disconnected(data, ack):
            print(AISocket.self, "disconnected data: \(data), ack: \(ack)")
            isConnected = false
            onDisconnect.send((data, ack))
        case let .text(text):
            print(AISocket.self, "received text: \(text)")

            if let data = text.data(using: .utf8) {
                handleDataResponse(data: data)
            }

            onText.send(text)
        case let .binary(data):
            print(AISocket.self, "received binary data: \(data)")

            handleDataResponse(data: data)

            onBinary.send(data)
        case let .pong(data):
            print(AISocket.self, "pong data: \(String(describing: data))")
            onPong.send(data)
        case let .ping(data):
            print(AISocket.self, "ping data: \(String(describing: data))")
            onPing.send(data)
        case let .error(error):
            print(AISocket.self, "received error: \(String(describing: error))")
            onError.send(error)
        case let .viabilityChanged(isChanged):
            print(AISocket.self, "viabilityChanged isChanged: \(isChanged)")
            onViabilityChanged.send(isChanged)
        case let .reconnectSuggested(isSuggested):
            print(AISocket.self, "reconnectSuggested isSuggested: \(isSuggested)")
            onReconnectSuggested.send(isSuggested)
        case .cancelled:
            print(AISocket.self, "cancelled")
            onCancelled.send(())
        case .peerClosed:
            print(AISocket.self, "peerClosed")
            onPeerClosed.send(())
        }
    }

    func handleDataResponse(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let eventName = json["event"] as? String
        {
            var newData: [String: Any] = [:]

            if let dataDict = json["data"] as? [String: Any] {
                newData = dataDict
            } else if let dataString = json["data"] as? String,
                      let dataData = dataString.data(using: .utf8),
                      let dataDict = try? JSONSerialization.jsonObject(with: dataData, options: []) as? [String: Any]
            {
                newData = dataDict
            } else if let dataDefault = json["data"] as? Any {
                newData["data"] = dataDefault
            }

            for (key, value) in json {
                if key != "event", key != "data" {
                    newData[key] = value
                }
            }

            if let callback = eventCallbacks[eventName] {
                callback(newData)
            }
        }
    }

    func connect(withPayload _: [String: Any]? = nil) {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    // MARK: - Emit

    func emit(event: AISocket.SocketEmitEventName? = nil, data: Any, completion: (() -> Void)? = nil) {
        guard isConnected else { return }
        emit(event: event?.rawValue, data: data, completion: completion)
    }

    func emit(event: String? = nil, data: Any, completion: (() -> Void)? = nil) {
        guard isConnected else { return }

        var dataToSend = data

        if let event = event {
            dataToSend = ["event": event, "data": data]
        }

        print(AISocket.self, "emitting: \(dataToSend)")

        if let text = dataToSend as? String {
            socket.write(string: text, completion: completion)
        } else if let binaryData = dataToSend as? Data {
            socket.write(data: binaryData, completion: completion)
        } else if let dictionary = dataToSend as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                socket.write(data: jsonData, completion: completion)
            } catch {
                print(AISocket.self, "Failed to convert dictionary to JSON data")
            }
        } else if let array = dataToSend as? [Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
                socket.write(data: jsonData, completion: completion)
            } catch {
                print(AISocket.self, "Failed to convert array to JSON data")
            }
        } else {
            print(AISocket.self, "Unsupported data type")
        }
    }

    // listen
    // live
    func listen(toEvent event: String, callback: @escaping AISocketEventCallback) {
        eventCallbacks[event] = callback
    }

    func listen(toEvent event: AISocket.SocketListenEventName, callback: @escaping AISocketEventCallback) {
        listen(toEvent: event.rawValue, callback: callback)
    }

    func listen<T: Decodable>(toEvent event: String, callback: @escaping (_ value: T) -> Void) {
        listen(toEvent: event, callback: { (data: AISocketDefaultResponseType) in
            let json = JSON(data)
            if T.self == JSON.self {
                callback(json as! T)
            } else if T.self == [String: Any].self {
                callback(json.dictionaryObject as! T)
            } else {
                if let value = Utils.decode(model: T.self, from: json) {
                    callback(value)
                }
            }
        })
    }

    func listen<T: Decodable>(toEvent event: AISocket.SocketListenEventName, callback: @escaping (_ value: T) -> Void) {
        return listen(toEvent: event.rawValue, callback: callback)
    }

    // once
    func listenOnce(toEvent event: String, callback: @escaping AISocketEventCallback) {
        listen(toEvent: event) { (data: AISocketDefaultResponseType) in
            callback(data)
            self.stopListening(toEvent: event)
        }
    }

    func listenOnce(toEvent event: AISocket.SocketListenEventName, callback: @escaping AISocketEventCallback) {
        listenOnce(toEvent: event.rawValue, callback: callback)
    }

    func listenOnce<T: Decodable>(toEvent event: String, callback: @escaping (_ value: T) -> Void) {
        listenOnce(toEvent: event) { (data: AISocketDefaultResponseType) in
            let json = JSON(data)
            if T.self == JSON.self {
                callback(json as! T)
            } else if T.self == [String: Any].self {
                callback(json.dictionaryObject as! T)
            } else {
                if let value = Utils.decode(model: T.self, from: json) {
                    callback(value)
                }
            }
        }
    }

    func listenOnce<T: Decodable>(toEvent event: AISocket.SocketListenEventName, callback: @escaping (_ value: T) -> Void) {
        listenOnce(toEvent: event.rawValue, callback: callback)
    }

    // stop listening
    func stopListening(toEvent event: String) {
        eventCallbacks[event] = nil
    }

    func stopListening(toEvent event: AISocket.SocketListenEventName) {
        stopListening(toEvent: event.rawValue)
    }

    func stopListeningToAllEvents() {
        eventCallbacks.removeAll()
    }
}

extension AISocket {
    struct SocketEmitEventName: RawRepresentable, Equatable {
        public var rawValue: String
        //    public typealias RawValue = String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static func == (lhs: SocketEmitEventName, rhs: SocketEmitEventName) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }

    struct SocketListenEventName: RawRepresentable, Equatable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static func == (lhs: SocketListenEventName, rhs: SocketListenEventName) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
}
