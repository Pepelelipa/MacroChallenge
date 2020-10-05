//
//  MarkdownQuote.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation
import UIKit

open class MarkdownQuote: MarkdownLevelElement {
    
    fileprivate static let regex = "^(\\>{1,%@})\\s*(.+)$"
    
    private static let quoteFont = MarkdownParser.defaultFont.light() ?? MarkdownParser.defaultFont
    private static let quoteColor = .actionColor ?? MarkdownParser.defaultColor

    private static var separator: String = ""
    public static var indicator: String = ""
    
    public static var isQuote = false
    
    open var maxLevel: Int
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    
    open var regex: String {
        let level: String = maxLevel > 0 ? "\(maxLevel)" : ""
        return String(format: MarkdownQuote.regex, level)
    }
    
    public init(font: MarkdownFont? = nil, maxLevel: Int = 0, indicator: String = "|",
                separator: String = "  ", color: MarkdownColor? = nil) {
        self.maxLevel = maxLevel
        self.font = font
        self.color = color
        
        MarkdownQuote.indicator = indicator
        MarkdownQuote.separator = separator
    }
    
    open func formatText(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        MarkdownQuote.formatQuoteStyle(attributedString, range: range, level: level)
    }
    
    public static func formatQuoteStyle(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        let string = "\(indicator)\(separator)"
        attributedString.replaceCharacters(in: range, with: string)

        attributedString.addAttributes(
            [
                .font: MarkdownQuote.quoteFont,
                .backgroundColor: MarkdownQuote.quoteColor,
                .foregroundColor: MarkdownQuote.quoteColor
            ],
            range: NSRange(location: range.location, length: 1)
        )
        
        isQuote = true
    }
    
    public static func checkQuoteIndicator(attributedText: NSAttributedString) -> Bool {
        var containsAttributes: Bool = false
        
        attributedText.enumerateAttributes(
            in: NSRange(location: 0, length: attributedText.length),
            options: []
        ) { (attributes, _, _) in
            if attributes.contains(where: { (attribute) -> Bool in
                
                if let font = attribute.value as? NSObject,
                   attribute.key == .font,
                   font == MarkdownQuote.quoteFont {
                    return true
                }
                return false
                
            }) {
                containsAttributes = true
            }
        }
        
        return containsAttributes
    }
}
