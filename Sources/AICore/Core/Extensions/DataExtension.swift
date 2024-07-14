//
//  DataExtension.swift
//
//
//  Created by Alexy Ibrahim on 5/15/23.
//

import Foundation
import UIKit

public extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        }
        return nil
    }
}
