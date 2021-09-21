//
//  HeaderElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct HeaderElement: MarkdownElement {
    // Non-capturing first group with start of string or (not word, not digit, not whitespace) or line feed, then 1 to 4 #,
    // followed by a whitespace + everything till end of line
    fileprivate static let regex = #"(?:^|[^\w\d\s]|\n)(#{1,4})( )(.{0,})"#
    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: HeaderElement.regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], Any?) {
        let fontStyle = FontStyle(rawValue: match.range(at: 1).length) ?? .paragraph
        let remainingContentRange = match.range(at: 3)
        if remainingContentRange.length > 0 {
            if let font = attributedString.getAttributeForKey(.font, at: remainingContentRange.location) as? UIFont {
                let newFont = font.toStyle(fontStyle)
                attributedString.addAttribute(.font, value: newFont, range: remainingContentRange)
            }
        }
        
        let deletionGroups = [match.range(at: 2), match.range(at: 1)]
        for deletion in deletionGroups {
            attributedString.deleteCharacters(in: deletion)
        }
        
        return (deletionGroups, fontStyle)
    }
}
