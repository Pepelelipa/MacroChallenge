//
//  MarkdownList.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation
import UIKit

open class MarkdownList: MarkdownLevelElement {
    
    fileprivate static let regex = "^( {0,%@}[\\*\\+\\-])\\s+(.+)$"
    
    public static let listFont = MarkdownParser.defaultFont
    public static var indicator: String = "●"
    public static var isList = false
    
    open var maxLevel: Int
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    open var separator: String
    
    open var regex: String {
        let level: String = maxLevel > 0 ? "\(maxLevel)" : ""
        return String(format: MarkdownList.regex, level)
    }
    
    public init(font: MarkdownFont? = nil, maxLevel: Int = 6, indicator: String = "●",
                separator: String = "  ", color: MarkdownColor? = nil) {
        self.maxLevel = maxLevel
        self.separator = separator
        self.font = font
        self.color = color
        MarkdownList.indicator = indicator
    }
    
    open func formatText(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        MarkdownList.formatListStyle(attributedString, range: range, level: level)
    }
    
    private static func defaultParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 16
        paragraphStyle.paragraphSpacing = 4
        return paragraphStyle
    }
    
    public static func formatListStyle(_ attributedString: NSMutableAttributedString, range: NSRange, level: Int) {
        let levelIndicatorList = [1: "\(indicator)  ", 2: "\(indicator)  ", 3: "◦  ", 4: "◦  ", 5: "▪︎  ", 6: "▪︎  "]
        let levelIndicatorOffsetList = [1: "", 2: "", 3: "  ", 4: "  ", 5: "    ", 6: "    "]
        guard let indicatorIcon = levelIndicatorList[level],
              let offset = levelIndicatorOffsetList[level] else { return }
        let indicator = "\(offset)\(indicatorIcon)"
        attributedString.replaceCharacters(in: range, with: indicator)
        attributedString.addAttributes([.paragraphStyle: defaultParagraphStyle(), .foregroundColor: MarkdownParser.defaultColor], range: range)
        attributedString.addAttribute(.font, value: MarkdownList.listFont, range: NSRange(location: range.location, length: 1))

        isList = true
    }
    
    public static func checkListIndicator(attributedText: NSAttributedString) -> Bool {
        var containsAttributes: Bool = false
        
        attributedText.enumerateAttributes(
            in: NSRange(location: 0, length: attributedText.length),
            options: []
        ) { (attributes, _, _) in
            if attributes.contains(where: { (attribute) -> Bool in
                
                if let font = attribute.value as? NSObject,
                   attribute.key == .font,
                   font == MarkdownList.listFont {
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
