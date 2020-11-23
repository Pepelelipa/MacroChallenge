//
//  MarkdownParser.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkdownParser {
    // MARK: Functions

    static let elements: [MarkdownElement] = [
        BoldElement(),
        ItalicElement(),
        UnderlineElement(),
        HighlightElement(),
        HeaderElement(),
        BulletListElement(),
        NumericListElement()
    ]
    ///Parses and returns how many characters were consumed
    internal static func parse(_ textToParse: NSMutableAttributedString) -> ([NSRange], Any?) {
        var consumedCharacters: [NSRange] = []
        var returnResult: Any?
        elements.forEach { (element) in
            let result = element.parse(textToParse)
            if let parseResult = result.1 {
                returnResult = parseResult
            }
            consumedCharacters.append(contentsOf: result.0)
        }
        return (consumedCharacters, returnResult)
    }
}
