//
//  AISocket.swift
//  Instant
//
//  Created by Alexy Ibrahim on 3/23/23.
//

import Foundation
import SocketIO
import Combine
import SwiftyJSON

public class AISocketIO {
    static var shared = AISocketIO()
    
    private(set) var manager: SocketManager!
    private(set) var socket: SocketIO.SocketIOClient!
    
    private(set) var isConnected: Bool = false
    private(set) var onConnect = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onDisconnect = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onError = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onPing = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onPong = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onReconnect = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onReconnectAttempt = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onStatusChange = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    private(set) var onWebsocketUpgrade = PassthroughSubject<(data: [Any], ack: SocketAckEmitter), Never>()
    
    init() {
        
    }
    
    init(host: String, port: Int, extraHeaders: [String: String]? = nil) {
        let config: SocketIOClientConfiguration = SocketIOClientConfiguration.init(arrayLiteral: .log(false), .compress)
        self.manager = SocketManager(socketURL: URL(string: "\(host):\(port)")!, config: config)
        
        if let extraHeaders = extraHeaders {
            self.manager.config.insert(.extraHeaders(extraHeaders), replacing: true)
        }
        
        self.socket = manager.defaultSocket
        
        self.initializeRequiredListeners()
    }
    
    final class func initShared(host: String, port: Int, extraHeaders: [String: String]? = nil) {
        AISocketIO.shared = AISocketIO.init(host: host, port: port, extraHeaders: extraHeaders)
    }
    
    func initializeRequiredListeners() {
        self.socket.on(clientEvent: .connect) { data, ack in
            self.isConnected = true
            self.onConnect.send((data, ack))
        }
        
        self.socket.on(clientEvent: .disconnect) { data, ack in
            self.isConnected = false
            self.onDisconnect.send((data, ack))
        }
        
        self.socket.on(clientEvent: .error) { data, ack in
            self.onError.send((data, ack))
        }
        
        self.socket.on(clientEvent: .ping) { data, ack in
            self.onPing.send((data, ack))
        }
        
        self.socket.on(clientEvent: .pong) { data, ack in
            self.onPong.send((data, ack))
        }
        
        self.socket.on(clientEvent: .reconnect) { data, ack in
            self.onReconnect.send((data, ack))
        }
        
        self.socket.on(clientEvent: .reconnectAttempt) { data, ack in
            self.onReconnectAttempt.send((data, ack))
        }
        
        self.socket.on(clientEvent: .statusChange) { data, ack in
            self.onStatusChange.send((data, ack))
        }
        
        self.socket.on(clientEvent: .websocketUpgrade) { data, ack in
            self.onWebsocketUpgrade.send((data, ack))
        }
    }
}

extension AISocketIO {
    func connect(withPayload payload: [String: Any]? = nil) {
        self.socket.connect(withPayload: payload)
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    // emit
    func emit(event: AISocketIO.SocketEmitEventName, data: SocketData..., completion: (() -> ())? = nil) {
        guard self.isConnected else { return }
        self.emit(event: event.rawValue, data: data, completion: completion)
    }
    
    func emit(event: String, data: SocketData..., completion: (() -> ())? = nil, callback: VoidClosure? = nil) {
        guard self.isConnected else { return }
        self.socket.emit(event, data, completion: completion)
    }
    
    func emitWithAck(event: AISocketIO.SocketEmitEventName, data: SocketData..., timeout: Double? = nil, callback: ((_ data: [Any]) -> ())? = nil, ackTimeoutCallback: ((_ data: [Any]) -> ())? = nil) {
        guard self.isConnected else { return }
        self.emitWithAck(event: event.rawValue, data: data, timeout: timeout, callback: callback, ackTimeoutCallback: ackTimeoutCallback)
    }
    
    func emitWithAck(event: String, data: SocketData..., timeout: Double? = nil, callback: ((_ data: [Any]) -> ())? = nil, ackTimeoutCallback: ((_ data: [Any]) -> ())? = nil) {
        guard self.isConnected else { return }
        self.socket.emitWithAck(event, data).timingOut(after: timeout ?? 0) { data in
            if (data.first as? String ?? "passed") == SocketAckStatus.noAck {
                ackTimeoutCallback?(data)
            } else {
                callback?(data)
            }
        }
    }
    
//    func emitAndListen<T: Codable>(event: String, data: SocketData..., listenOn listenOnEvent: String? = nil, completion: (() -> ())? = nil, callback: @escaping (_ value: T, _ ack: SocketAckEmitter) -> ()) {
//        guard self.isConnected else { return }
//        
//        let uuid = self.listen(toEvent: listenOnEvent) { (value: SocketResponseModel<T>, ack) in
//            if value.request_id == uuid.uuidString {
//                callback(value.data, ack)
//                self.stopListening(toId: uuid)
//            }
//        }
//        
//        let eventData = ["request_id": UUID().uuidString, "payload": data] as [String : Any]
//        self.socket.emit(event, eventData, completion: completion)
//    }
    
    // listen
    // live
    func listen(toEvent event: String, callback: @escaping (_ data: [Any], _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.socket.on(event, callback: callback)
    }
    
    func listen(toEvent event: AISocketIO.SocketListenEventName, callback: @escaping (_ data: [Any], _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listen(toEvent: event.rawValue, callback: callback)
    }
    
    func listen<T: Decodable>(toEvent event: String, callback: @escaping (_ value: T, _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listen(toEvent: event) { data, ack in
            if let first = data.first {
                let json = JSON.init(first)
                if T.self == JSON.self {
                    callback(json as! T, ack)
                } else if T.self == Dictionary<String, Any>.self {
                    callback(json.dictionaryObject as! T, ack)
                } else {
					if let data = Utils.decode(model: T.self, from: json) {
						callback(data, ack)
					}
                }
            }
        }
    }
    
    func listen<T: Decodable>(toEvent event: AISocketIO.SocketListenEventName, callback: @escaping (_ value: T, _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listen(toEvent: event.rawValue, callback: callback)
    }
    
    // once
    func listenOnce(toEvent event: String, callback: @escaping (_ data: [Any], _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.socket.once(event, callback: callback)
    }
    
    func listenOnce(toEvent event: AISocketIO.SocketListenEventName, callback: @escaping (_ data: [Any], _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listenOnce(toEvent: event.rawValue, callback: callback)
    }
    
    func listenOnce<T: Decodable>(toEvent event: String, callback: @escaping (_ value: T, _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listenOnce(toEvent: event) { data, ack in
            if let first = data.first {
                let json = JSON.init(first)
                if T.self == JSON.self {
                    callback(json as! T, ack)
                } else if T.self == Dictionary<String, Any>.self {
                    callback(json.dictionaryObject as! T, ack)
                } else {
					if let data = Utils.decode(model: T.self, from: json) {
						callback(data, ack)
					}
                }
            }
        }
    }
    
    func listenOnce<T: Decodable>(toEvent event: AISocketIO.SocketListenEventName, callback: @escaping (_ value: T, _ ack: SocketAckEmitter) -> ()) -> UUID {
        return self.listenOnce(toEvent: event.rawValue, callback: callback)
    }
    
    // stop listening
    func stopListening(toEvent event: String) {
        self.socket.off(event)
    }
    
    func stopListening(toEvent event: AISocketIO.SocketListenEventName) {
        self.stopListening(toEvent: event.rawValue)
    }
    
    func stopListening(toClientEvent event: SocketClientEvent) {
        self.socket.off(clientEvent: event)
    }
    
    func stopListening(toId id: UUID) {
        self.socket.off(id: id)
    }
    
    func stopListening(toId id: String) {
        if let uuid = UUID(uuidString: id) {
            self.stopListening(toId: id)
        }
    }
}

extension AISocketIO {
    struct SocketEmitEventName: RawRepresentable, Equatable {
        public var rawValue: String
    //    public typealias RawValue = String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func ==(lhs: SocketEmitEventName, rhs: SocketEmitEventName) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }


    struct SocketListenEventName: RawRepresentable, Equatable {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func ==(lhs: SocketListenEventName, rhs: SocketListenEventName) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
}
