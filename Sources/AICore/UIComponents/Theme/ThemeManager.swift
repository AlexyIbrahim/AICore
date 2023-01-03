//
//  ThemeManager.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation
import UIKit

public final class ThemeManager {
    /// The current theme.
    public var current: Theme
    public private(set) var currentTheme: ThemeName {
        didSet {
            self.current = self.currentTheme.theme
        }
    }
    
    public static var shared: ThemeManager = ThemeManager(defaultTheme: .main)

    /// Creates a theme manager.
    ///
    /// - Parameter defaultTheme: The default theme.
    private init(defaultTheme: ThemeName) {
        self.currentTheme = defaultTheme
        self.current = self.currentTheme.theme
    }
    
    public func setTheme(_ themeType: ThemeName) {
        self.currentTheme = themeType
    }
    
}
