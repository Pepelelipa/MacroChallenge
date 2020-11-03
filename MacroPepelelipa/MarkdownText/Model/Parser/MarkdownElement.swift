//
//  MarkdownElement.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

internal protocol MarkdownElement {
    func regularExpression() throws -> NSRegularExpression
    ///Parses the attributed text and returns how many characters were consumed
    func parse(_ attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?)
    ///Matches the attributed text and returns how many characters were consumed
    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?)
}

internal extension MarkdownElement {
    func parse(_ attributedString: NSMutableAttributedString) -> ([NSRange], ListStyle?) {
        var consumedCharacters: [NSRange] = []
        var list: ListStyle?
        var location = 0
        do {
            let regex = try regularExpression()

            while let regexMatch = regex.firstMatch(
                in: attributedString.string,
                options: .withoutAnchoringBounds,
                range: NSRange(location: location,
                               length: attributedString.length - location)
            ) {
                let oldLength = attributedString.length
                let result = match(regexMatch, attributedString: attributedString)
                if let resultList = result.1 {
                    list = resultList
                }
                consumedCharacters.append(contentsOf: result.0)
                let newLength = attributedString.length
                location = regexMatch.range.location + regexMatch.range.length + newLength - oldLength
            }
        } catch let error { print(error.localizedDescription) }
        return (consumedCharacters, list)
    }
}

