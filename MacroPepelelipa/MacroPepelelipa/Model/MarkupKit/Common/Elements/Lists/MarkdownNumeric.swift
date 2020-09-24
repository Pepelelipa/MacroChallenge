//
//  MarkdownNumeric.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

open class MarkdownNumeric: MarkdownLevelElement {
    
    fileprivate static let regex = "^( {0,%@}1[\\.\\-\\)])\\s+(.+)$"
    
    public static let numericFont = MarkdownParser.defaultFont.bold() ?? MarkdownParser.defaultFont
    
    public static var isNumeric = false {
        didSet {
            if !isNumeric {
                nextNumber = 1
            }
        }
    }
    
    open var maxLevel: Int
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    
    private static var nextNumber: Int = 1
    
    open var regex: String {
        let level: String = maxLevel > 0 ? "\(maxLevel)" : ""
        return String(format: MarkdownNumeric.regex, level)
    }
    
    public init(font: MarkdownFont? = nil, maxLevel: Int = 2, color: MarkdownColor? = nil) {
        self.maxLevel = maxLevel
        self.font = font
        self.color = color
    }
    
    open func formatText(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        MarkdownNumeric.formatListStyle(attributedString, range: range, level: level)
    }
    
    public static func formatListStyle(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        
        let firstCharacter = attributedString.attributedSubstring(from: NSRange(location: range.location, length: 1)).string
        
        let indicator = ". "
        
        if firstCharacter != "1" {
            attributedString.replaceCharacters(
                in: range,
                with: "\(nextNumber)\(indicator)"
            )
        } else {
            attributedString.replaceCharacters(
                in: NSRange(location: range.location + 1, length: range.length - 1),
                with: indicator
            )
        }
        
        attributedString.addAttribute(.foregroundColor, value: MarkdownParser.defaultColor, range: range)
        attributedString.addAttribute(.font, value: MarkdownNumeric.numericFont, range: NSRange(location: range.location, length: 2))
        isNumeric = true
    }
    
    public static func updateNumber(isBackspace: Bool) {
        if isBackspace {
            nextNumber -= 1
        } else {
            nextNumber += 1
        }
    }
    
}
