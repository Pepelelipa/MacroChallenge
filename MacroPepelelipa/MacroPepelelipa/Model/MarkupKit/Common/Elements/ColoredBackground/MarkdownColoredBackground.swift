//
//  MarkdownColoredBackground.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

open class MarkdownColoredBackground: MarkdownCommonElement {
    
    public var font: MarkdownFont?
    public var color: MarkdownColor?
    public var textHighlightColor: MarkdownColor?
    public var textBackgroundColor: MarkdownColor?
    
    public var regex: String {
        return ""
    }
   
    public func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        let matchString: String = attributedString.attributedSubstring(from: range).string
        guard let unescapedString = matchString.unescapeUTF16() else {
            return
        }
        attributedString.replaceCharacters(in: range, with: unescapedString)
        
        var codeAttributes = attributes
        
        textHighlightColor.flatMap { codeAttributes[NSAttributedString.Key.foregroundColor] = $0 }
        textBackgroundColor.flatMap { codeAttributes[NSAttributedString.Key.backgroundColor] = $0 }
        font.flatMap { codeAttributes[NSAttributedString.Key.font] = $0 }
        
        let updatedRange = (attributedString.string as NSString).range(of: unescapedString)
        attributedString.addAttributes(codeAttributes, range: NSRange(location: range.location, length: updatedRange.length))
    }
    
}
