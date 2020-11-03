//
//  NumericListElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct NumericListElement: MarkdownElement {
    fileprivate static let regex = "^( {0,1}1[\\.\\-\\)] )$"
    func regularExpression() throws -> NSRegularExpression {
        return try NSRegularExpression(pattern: NumericListElement.regex, options: .anchorsMatchLines)
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?) {
        attributedString.deleteCharacters(in: match.range(at: 1))
        return ([match.range(at: 1)], .numeric)
    }
}

