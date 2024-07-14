//
//  AIAttributedString.swift
//  Fibler2
//
//  Created by Alexy Ibrahim on 12/18/18.
//  Copyright © 2018 siegma. All rights reserved.
//

import UIKit

@objcMembers public class AIAttributedString: NSObject {
    static let sharedInstance = AIAttributedString()

    var mainString: String!
    private var attributedString: NSMutableAttributedString!
    var urlCallbacks = [String: (String) -> Void]()

    override public init() {
        mainString = ""
        attributedString = NSMutableAttributedString(string: mainString)
    }

    public init(withMainString mainString: String) {
        self.mainString = mainString
        attributedString = NSMutableAttributedString(string: self.mainString)
    }

    public init(withAttributedString attributedString: NSAttributedString) {
        mainString = attributedString.string
        self.attributedString = NSMutableAttributedString(attributedString: attributedString)
    }

    public final func appendString(string: String) -> AIAttributedString {
        mainString += string
        attributedString.append(NSAttributedString(string: string))

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withTextColor textColor: UIColor) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.foregroundColor, value: textColor)

        return self
    }

    public final func addAttribute(alignment: NSTextAlignment) -> AIAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        addAttribute(forSubstring: nil, attributeKey: NSAttributedString.Key.paragraphStyle, value: paragraph)

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withFont font: UIFont) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.font, value: font)

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withUnderlineAreaColor color: UIColor? = nil) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue)
        if let color = color {
            addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.foregroundColor, value: color)
        }

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withBackgroundColor backgroundColor: UIColor) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.backgroundColor, value: backgroundColor)

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withUrl url: String, color: UIColor? = nil) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.link, value: URL(string: url)!)
        if let color = color {
            addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.foregroundColor, value: color)
        }

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withBaselineOffset baselineOffset: CGFloat) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.baselineOffset, value: baselineOffset)

        return self
    }

    public final func addAttribute(forSubstring string: String? = nil, withParagprahStyle paragprahStyle: NSParagraphStyle) -> AIAttributedString {
        addAttribute(forSubstring: string, attributeKey: NSAttributedString.Key.paragraphStyle, value: paragprahStyle)

        return self
    }

//    final func clickable(onString string:String? = nil, _ callback: @escaping ((_ link: String) -> ())) -> AIAttributedString {
//        var range = NSMakeRange(0, self.mainString.count)
//        if let string = string {
//            range = (self.mainString as NSString).range(of: string)
//        }
//
//
//        let unEscapedString = (self.attributedString.string as NSString).substring(with: range)
//        let escapedString = unEscapedString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed) ?? ""
//        self.attributedString.addAttribute(NSAttributedString.Key.link, value: URL(string: "http://www.google.com")!, range: range)
    ////        self.attributedString.addAttribute(NSAttributedString.Key.link, value: "AttributedTextView:\(escapedString)", range: range)
//        urlCallbacks[unEscapedString] = callback
//
//
//
//
    ////        let attributedLinkString = NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: "http://www.google.com")!])
    ////        let fullAttributedString = NSMutableAttributedString()
    ////        fullAttributedString.append(plainAttributedString)
    ////        fullAttributedString.append(attributedLinkString)
    ////        attributedLabel.attributedText = fullAttributedString
//
//        return self
//    }
//
//    public func interactWithURL(URL: URL) {
//        let unescapedString = URL.absoluteString.replacingOccurrences(of: "AttributedTextView:", with: "").removingPercentEncoding ?? ""
//        urlCallbacks[unescapedString]?(unescapedString)
//    }

    public final func addImage(image: UIImage) -> AIAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)

        attributedString.append(imageString)

        return self
    }

    private final func addAttribute(forSubstring string: String? = nil, attributeName: String, value: Any) {
        addAttribute(forSubstring: string, attributeKey: convertToNSAttributedStringKey(attributeName), value: value)
    }

    private final func addAttribute(forSubstring string: String? = nil, attributeKey: NSAttributedString.Key, value: Any) {
        var range = NSMakeRange(0, mainString.count)
        if let string = string {
            range = (mainString as NSString).range(of: string)
        }
        attributedString.addAttribute(attributeKey, value: value, range: range)
    }

    private final func addAttributes(forSubstring string: String? = nil, attributes: [String: Any]) {
        addAttributes(forSubstring: string, attributes: attributes.reduce(into: [NSAttributedString.Key: Any]()) { result, pair in
            result[convertToNSAttributedStringKey(pair.key)] = pair.value
        })
    }

    private final func addAttributes(forSubstring string: String? = nil, attributes: [NSAttributedString.Key: Any]) {
        var range = NSMakeRange(0, mainString.count)
        if let string = string {
            range = (mainString as NSString).range(of: string)
        }
        attributedString.addAttributes(attributes, range: range)
    }

    public final func text(alignment _: NSTextAlignment? = nil) -> NSAttributedString {
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = alignment ?? .left

        return NSAttributedString(attributedString: attributedString)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToNSAttributedStringKey(_ input: String) -> NSAttributedString.Key {
    return NSAttributedString.Key(rawValue: input)
}

extension String {
    func attributedString() -> AIAttributedString {
        return AIAttributedString(withMainString: self)
    }
}

extension NSAttributedString {
    func attributedString() -> AIAttributedString {
        return AIAttributedString(withAttributedString: self)
    }
}

public extension NSMutableAttributedString {
    func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet as CharacterSet)

        // Trim leading characters from character set.
        while range.length != 0, range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }

        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0, NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}
