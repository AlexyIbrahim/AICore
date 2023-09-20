//
//  KeychainHelper.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 12/2/22.
//

import Foundation
import Security
import LocalAuthentication

public protocol KeychainServiceProtocol {
    static var id: String { get }
    static var keychainService: KeychainService { get }
    static func save(value: String)
    static func read() -> String?
    static func delete()
	static func exist() -> Bool
}

public extension KeychainServiceProtocol {
    static var keychainService: KeychainService {
        KeychainService(key: self.id)
    }
    
    static func save(value: String) {
        keychainService.save(text: value)
    }
    
    static func read() -> String? {
        if let value: String = keychainService.read() {
            return value
        }
        
        return nil
    }
    
    static func delete() {
        keychainService.delete()
    }
}

public class KeychainService {
    private var key: String
    
    init(key: String) {
        self.key = key
    }
    
    public func save(text: String) -> Bool {
        delete()
        let textData = text.data(using: .utf8)!
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: textData]
        let status = SecItemAdd(query as CFDictionary, nil)
        print("Value for key \(key) Added to Keychain: \(status == errSecSuccess)")
        return status == errSecSuccess
    }
    
    public func read() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecReturnData as String: true,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true, //  If you set the value of kSecReturnAttributes to true, the search results will include the attributes of the Keychain item, such as the creation and modification dates, access control information, and metadata
                                    
                                    // prompt for the user
                                    kSecUseAuthenticationContext as String: LAContext()]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let textData = existingItem[kSecValueData as String] as? Data,
               let text = String(data: textData, encoding: .utf8) {
                return text
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    @discardableResult public func delete() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
	
	public func exist() -> Bool {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key,
									kSecReturnData as String: true,
									kSecMatchLimit as String: kSecMatchLimitOne,
									kSecReturnAttributes as String: true,
									kSecUseAuthenticationContext as String: LAContext()]
		
		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		return status == errSecSuccess
	}
}
