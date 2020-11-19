//
//  BoldElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct BoldElement: MarkdownElement {
    fileprivate static let regex = "(.?|^)(\\*\\*|__)(?=\\S)(.+?)(?<=\\S)(\\2)"
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: BoldElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], Any?) {
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 4))
        // setting bold
        let range = match.range(at: 3)
        attributedString.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { (value, atRange, _) in
            if var font = value as? UIFont {
                if font.hasTrait(.traitBold) {
                    font = font.removeTrait(.traitBold)
                } else if let boldFont = font.bold() {
                    font = boldFont
                }
                attributedString.addAttribute(.font, value: font, range: atRange)
            }
        }
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 2))
        return ([match.range(at: 4), match.range(at: 2)], nil)
    }
}
