//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 5/15/23.
//

import Foundation


public extension Character {
    var isWhitespace: Bool {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let scalar = String(self).unicodeScalars.first!
        return whitespaceCharacterSet.contains(scalar)
    }
}
