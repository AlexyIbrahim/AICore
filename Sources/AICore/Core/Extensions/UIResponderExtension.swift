//
//  UIResponderExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension UIResponder: Identifiable {
    
    public static var identifier: String { String(describing: self) }
}
