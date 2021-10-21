//
//  AttributedString Extension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension NSAttributedString {
    func withForegroundColor(_ color: UIColor, in range: NSRange? = nil) -> NSAttributedString {
        let newRange = range ?? NSRange(location: 0, length: length)
        return self.withExtraAttribute((.foregroundColor, color), in: newRange)
    }

    func withExtraAttribute(_ attribute: (NSAttributedString.Key, Any), in range: NSRange) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.addAttribute(attribute.0, value: attribute.1, range: range)
        return mutableString
    }

    func replaceColors(with colors: [UIColor] = [UIColor.bodyColor ?? .black, UIColor.notebookColors[4], UIColor.notebookColors[14]]) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.enumerateAttribute(.foregroundColor, in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (color, range, _) in
            if let color = color as? UIColor {
                var newColor: UIColor?
                for i in 0 ..< colors.count {
                    if colors[i].compareRGB(color) {
                        newColor = colors[i]
                        break
                    }
                }
                if let newColor = newColor {
                    mutableString.addAttribute(.foregroundColor, value: newColor, range: range)
                }
            }
        }

        mutableString.enumerateAttribute(.backgroundColor, in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (color, range, _) in
            if let color = color as? UIColor {
                var newColor: UIColor?
                for i in 0 ..< colors.count {
                    if colors[i].compareRGB(color) {
                        newColor = colors[i]
                        break
                    }
                }
                if let newColor = newColor {
                    mutableString.addAttribute(.backgroundColor, value: newColor, range: range)
                }
            }
        }

        return mutableString
    }

    func addingBulletList() -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.insert(NSAttributedString(string: "\u{2022}"), at: 0)
        return mutableAttributedString.withExtraAttribute((.kern, 0), in: NSRange(location: 0, length: 1))
    }
}
