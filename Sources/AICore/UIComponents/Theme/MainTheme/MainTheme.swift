//
//  MainTheme.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import Foundation

public class MainTheme: Theme {
    
    required public init() {}
    public var color: MainColorTheme { MainColorTheme() }
    public var label: MainLabelTheme { MainLabelTheme() }
    public var button: MainButtonTheme { MainButtonTheme() }
}
