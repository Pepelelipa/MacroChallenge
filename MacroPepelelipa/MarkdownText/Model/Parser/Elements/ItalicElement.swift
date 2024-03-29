//
//  ItalicElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct ItalicElement: MarkdownElement {
    fileprivate static let regex = "(-)(.*?)(-)"
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: ItalicElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], Any?) {
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 3))
        // setting bold
        let range = match.range(at: 2)
        attributedString.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { (value, atRange, _) in
            if var font = value as? UIFont {
                if font.hasTrait(.traitItalic) {
                    font = font.removeTrait(.traitItalic)
                } else if let italicFont = font.italic() {
                    font = italicFont
                }
                attributedString.addAttribute(.font, value: font, range: atRange)
            }
        }
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 1))
        return ([match.range(at: 3), match.range(at: 1)], nil)
    }
}
