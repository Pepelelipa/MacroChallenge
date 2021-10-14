//
//  HighlightElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct HighlightElement: MarkdownElement {
    fileprivate static let regex = "(::)(.*?)(::)"
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: HighlightElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], Any?) {
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 3))
        // setting bold
        let range = match.range(at: 2)
        attributedString.enumerateAttribute(.backgroundColor, in: range, options: .longestEffectiveRangeNotRequired) { (value, range, _) in
            if (value as? UIColor) == UIColor.highlightColor {
                attributedString.addAttribute(.backgroundColor, value: UIColor.clear, range: range)
            } else {
                attributedString.addAttribute(.backgroundColor, value: UIColor.highlightColor ?? .systemYellow, range: range)
            }
        }
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 1))
        return ([match.range(at: 3), match.range(at: 1)], nil)
    }
}
