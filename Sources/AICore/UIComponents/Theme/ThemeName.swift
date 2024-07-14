//
//  ThemeName.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation

public enum ThemeName: String, CaseIterable {
    case main

    public var identifier: String {
        switch self {
        case .main:
            return "main"
        }
    }

    var theme: Theme {
        switch self {
        case .main:
            return MainTheme()
        }
    }
}
