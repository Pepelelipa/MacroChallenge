//
//  NSAttributedString Extension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal extension NSAttributedString {
    static func defaultAttributesForStyle(_ style: FontStyle) -> [NSAttributedString.Key : Any] {
        return [.font: UIFont.defaultFont.toStyle(style), .foregroundColor: UIColor.bodyColor ?? UIColor.black ]
    }

    func removeAttribute(_ attributte: (NSAttributedString.Key), in range: NSRange) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.removeAttribute(attributte, range: range)
        return mutableString
    }

    func withExtraAttribute(_ attribute: (NSAttributedString.Key, Any), in range: NSRange) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.addAttribute(attribute.0, value: attribute.1, range: range)
        return mutableString
    }

    func getAttributeForKey(_ key: NSAttributedString.Key, at location: Int) -> Any? {
        return attributes(at: location, effectiveRange: nil).first(where: { $0.key == key })
    }

    func hasKern(at location: Int) -> Bool {
        return getAttributeForKey(.kern, at: location) != nil
    }

    func withForegroundColor(_ color: UIColor, in range: NSRange? = nil) -> NSAttributedString {
        let newRange = range ?? NSRange(location: 0, length: length)
        return self.withExtraAttribute((.foregroundColor, color), in: newRange)
    }

    ///Returns a sample of the string backward from the location
    func smallBackwardSample(_ length: Int = 250, location: Int) -> NSAttributedString {
        let actualLocation = max(0, location - length)
        let actualLength = min(location - actualLocation, self.length - actualLocation)
        return attributedSubstring(from: NSRange(location: actualLocation, length: actualLength))
    }

    ///Returns a sample of the string forward from the location
    func smallForwardSample(_ length: Int = 250, location: Int) -> NSAttributedString {
        let actualLocation = max(0, location)
        let actualLength = min(length, self.length - actualLocation)
        return attributedSubstring(from: NSRange(location: actualLocation, length: actualLength))
    }

    ///Returns a sample of the string forward and backward from the location (length * 2)
    func smallAroundSample(_ length: Int = 250, location: Int) -> (NSAttributedString, NSRange) {
        let actualLocation = max(0, location - length)
        let actualLength = min(length * 2, self.length - actualLocation)
        let range = NSRange(location: actualLocation, length: actualLength)
        return (attributedSubstring(from: range), range)
    }

    ///Finds out if the line is in a list, by checking its first character
    func startsWithList() -> ListStyle? {
        var value: ListStyle?
        enumerateAttributes(in: NSRange(location: 0, length: min(1, length)), options: .longestEffectiveRangeNotRequired) { (keys, _, _) in
            if hasKern(at: 0),
               let paragraphStyle = keys[.paragraphStyle] as? NSParagraphStyle,
               paragraphStyle == ListStyle.paragraphStyle {
                let prefix = string.prefix(min(1, length))
                if prefix == ListStyle.bullet.indicator {
                    value = .bullet
                } else {
                    value = .numeric
                }
            }
        }
        return value
    }

    func split(separatedBy separator: String) -> [NSAttributedString] {
        var result = [NSAttributedString]()
        let separatedStrings = string.components(separatedBy: separator)
        var range = NSRange(location: 0, length: 0)
        for string in separatedStrings {
            range.length = string.count
            let attributedString = attributedSubstring(from: range)
            result.append(attributedString)
            range.location += range.length + separator.count
        }
        return result
    }
}

