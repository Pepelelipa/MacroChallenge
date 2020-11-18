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

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], Any?) {
        let deletionRange = match.range(at: 0)
        attributedString.deleteCharacters(in: deletionRange)

        return ([deletionRange], FontStyle(rawValue: match.range(at: 1).length))
    }
}
