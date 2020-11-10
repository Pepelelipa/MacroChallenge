//
//  HeaderElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct HeaderElement: MarkdownElement {
    fileprivate static let regex = "(#{1,4})( )"
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: HeaderElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?) {
        let range = match.range(at: 2)
        let deletionRange = match.range(at: 1)
        attributedString.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired, using: { (font, range, _) in
            if let font = font as? UIFont, let style = FontStyle(rawValue: deletionRange.length) {
                attributedString.addAttribute(.font, value: font.toStyle(style), range: range)
            }
        })
        attributedString.deleteCharacters(in: match.range(at: 1))

        return ([match.range(at: 1)], nil)
    }
}
