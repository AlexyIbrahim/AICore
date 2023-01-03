//
//  UIColorExtension.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/4/22.
//

import Foundation
import UIKit

public extension UIColor {
    //    public convenience init?(hex: String) {
    //        let r, g, b, a: CGFloat
    //
    //        if hex.hasPrefix("#") {
    //            let start = hex.index(hex.startIndex, offsetBy: 1)
    //            let hexColor = String(hex[start...])
    //
    //            if hexColor.count == 8 {
    //                let scanner = Scanner(string: hexColor)
    //                var hexNumber: UInt64 = 0
    //
    //                if scanner.scanHexInt64(&hexNumber) {
    //                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
    //                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
    //                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
    //                    a = CGFloat(hexNumber & 0x000000ff) / 255
    //
    //                    self.init(red: r, green: g, blue: b, alpha: a)
    //                    return
    //                }
    //            }
    //        }
    //
    //        return nil
    //    }

    convenience init?(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            //                cString.remove(at: cString.startIndex)
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
