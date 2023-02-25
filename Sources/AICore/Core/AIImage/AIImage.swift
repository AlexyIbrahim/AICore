//
//  AIImage.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import UIKit

public struct AIImage {
    
    // internal resolved image
    private var resolvedImage: UIImage
    
    // returns uicolor value
    public var image: UIImage { resolvedImage }
    
    public init(from image: UIImage) {
        resolvedImage = image
    }
    
    public init(systemName name: String) {
        resolvedImage = .init(systemName: name)!
    }
}
