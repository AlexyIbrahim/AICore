//
//  Theme.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation

public protocol Theme {
    init()
    var color: MainColorTheme { get }
    var label: MainLabelTheme { get }
    var button: MainButtonTheme { get }
}
