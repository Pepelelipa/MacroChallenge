//
//  UnderlineElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct UnderlineElement: MarkdownElement {
    fileprivate static let regex = "(.?|^)(\\~\\~|__)(?=\\S)(.+?)(?<=\\S)(\\2)"
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: UnderlineElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?) {
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 4))
        // setting bold
        let range = match.range(at: 3)
        attributedString.enumerateAttribute(.underlineStyle, in: range, options: .longestEffectiveRangeNotRequired) { (value, range, _) in
            if value != nil {
                attributedString.removeAttribute(.underlineStyle, range: range)
            } else {
                attributedString.addAttribute(.underlineStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: range)
            }
        }
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 2))
        return ([match.range(at: 4), match.range(at: 2)], nil)
    }
}
