//
//  Constants.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/8/22.
//

import Foundation


public typealias GenericClosure<T> = (T) -> Void
public typealias VoidClosure = () -> Void

class Constants {
	static internal let bundleId: String = Bundle.main.bundleIdentifier!
}
