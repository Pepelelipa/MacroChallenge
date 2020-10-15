//
//  MarkdownParser.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation
import UIKit

/**
 This class is responsible to parse the markup text according to the markup elements determined in it.
 */
open class MarkdownParser {
    public struct EnabledElements: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static let automaticLink = EnabledElements(rawValue: 1)
        public static let header        = EnabledElements(rawValue: 1 << 1)
        public static let list          = EnabledElements(rawValue: 1 << 2)
        public static let quote         = EnabledElements(rawValue: 1 << 3)
        public static let link          = EnabledElements(rawValue: 1 << 4)
        public static let bold          = EnabledElements(rawValue: 1 << 5)
        public static let italic        = EnabledElements(rawValue: 1 << 6)
        public static let code          = EnabledElements(rawValue: 1 << 7)
        public static let strikethrough = EnabledElements(rawValue: 1 << 8)
        public static let highlight     = EnabledElements(rawValue: 1 << 9)
        public static let numeric       = EnabledElements(rawValue: 1 << 10)
        
        public static let disabledAutomaticLink: EnabledElements = [
            .header,
            .list,
            .quote,
            .link,
            .bold,
            .italic,
            .code,
            .strikethrough,
            .highlight,
            .numeric
        ]
        
        public static let all: EnabledElements = [
            .disabledAutomaticLink,
            .automaticLink
        ]
    }
    
    // MARK: - Element Arrays
    fileprivate var escapingElements: [MarkdownElement]
    fileprivate var defaultElements: [MarkdownElement] = []
    fileprivate var unescapingElements: [MarkdownElement]
    
    open var customElements: [MarkdownElement]
    
    // MARK: - Basic Elements
    public let header: MarkdownHeader
    public let list: MarkdownList
    public let quote: MarkdownQuote
    public let link: MarkdownLink
    public let automaticLink: MarkdownAutomaticLink
    public let bold: MarkdownBold
    public let italic: MarkdownItalic
    public let code: MarkdownCode
    public let strikethrough: MarkdownStrikethrough
    public let highlight: MarkdownHighlight
    public let numeric: MarkdownNumeric
    
    // MARK: - Escaping Elements
    fileprivate var codeEscaping = MarkdownCodeEscaping()
    fileprivate var escaping = MarkdownEscaping()
    fileprivate var unescaping = MarkdownUnescaping()
    
    // MARK: - Configuration
    /// Enables individual Markdown elements and automatic link detection
    open var enabledElements: EnabledElements {
        didSet {
            updateDefaultElements()
        }
    }
    
    public var font: MarkdownFont
    public var color: MarkdownColor
    public var backgroundColor: MarkdownColor
    
    // MARK: - Legacy Initializer
    @available(*, deprecated, renamed: "init", message: "This constructor will be removed soon, please use the new opions constructor")
    public convenience init(automaticLinkDetectionEnabled: Bool,
                            font: MarkdownFont = MarkdownParser.defaultFont,
                            customElements: [MarkdownElement] = []) {
        let enabledElements: EnabledElements = automaticLinkDetectionEnabled ? .all : .disabledAutomaticLink
        self.init(font: font, enabledElements: enabledElements, customElements: customElements)
    }
    
    // MARK: - Initializer
    public init(font: MarkdownFont = MarkdownParser.defaultFont,
                color: MarkdownColor = MarkdownParser.defaultColor,
                enabledElements: EnabledElements = .all,
                customElements: [MarkdownElement] = []) {
        self.font = font
        self.color = color
        self.backgroundColor = UIColor.clear
        
        header = MarkdownHeader(font: font)
        list = MarkdownList(font: font)
        quote = MarkdownQuote(font: font)
        link = MarkdownLink(font: font)
        automaticLink = MarkdownAutomaticLink(font: font)
        bold = MarkdownBold(font: font)
        italic = MarkdownItalic(font: font)
        code = MarkdownCode(font: font)
        strikethrough = MarkdownStrikethrough(font: font)
        highlight = MarkdownHighlight(font: font, textHighlightColor: UIColor.bodyColor ?? .black, textBackgroundColor: UIColor.yellow)
        numeric = MarkdownNumeric(font: font)
        
        self.escapingElements = [codeEscaping, escaping]
        self.unescapingElements = [code, unescaping]
        self.customElements = customElements
        self.enabledElements = enabledElements
        updateDefaultElements()
    }
    
    // MARK: - Element Extensibility
    open func addCustomElement(_ element: MarkdownElement) {
        customElements.append(element)
    }
    
    open func removeCustomElement(_ element: MarkdownElement) {
        guard let index = customElements.firstIndex(where: { someElement -> Bool in
            return element === someElement
        }) else {
            return
        }
        customElements.remove(at: index)
    }
    
    // MARK: - Parsing
    
    /**
        This method parses a simple string into a NSAttributedString.
     
        - Parameters:
            - markdown: The string that will be parsed.
     
        - Returns: An NSAttributedString parsed from the received string.
     
     */
    open func parse(_ markdown: String) -> NSAttributedString {
        let string = NSAttributedString(string: markdown)
        return parse(NSAttributedString(string: markdown), range: NSRange(location: 0, length: string.length), isBackspace: false)
    }
    
    /**
        This method parses the text of a NSAttributedString and returns another NSAttributedString after parsing the text. The method takes into consideration the range to parsed, in order to not overrides the existing attributes in the original string. Also, this method does not override any attributes in case of text deletion.
     
        - Parameters:
            - markdown: The NSAttributedString which text will be parsed.
            - range: An NSRange indicating the range that will receive new attributes.
            - isBackspace: A boolean indicating if there was text deletion or not.
     
        - Returns: An NSAttributedString parsed from the received string.
     
     */
    open func parse(_ markdown: NSAttributedString, range: NSRange, isBackspace: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: markdown)
                
        if !isBackspace {
            attributedString.addAttribute(.font, value: font,
                                          range: NSRange(location: range.location, length: range.length + 1))
            attributedString.addAttribute(.foregroundColor, value: color,
                                          range: NSRange(location: range.location, length: range.length + 1))
            attributedString.addAttribute(.backgroundColor, value: backgroundColor,
                                          range: NSRange(location: range.location, length: range.length + 1))
        }
        var elements: [MarkdownElement] = escapingElements
        elements.append(contentsOf: defaultElements)
        elements.append(contentsOf: customElements)
        elements.append(contentsOf: unescapingElements)
        elements.forEach { element in
            element.parse(attributedString)
        }
                
        return attributedString
    }
    
    fileprivate func updateDefaultElements() {
        let pairs: [(EnabledElements, MarkdownElement)] = [
            (.automaticLink, automaticLink),
            (.header, header),
            (.list, list),
            (.quote, quote),
            (.link, link),
            (.bold, bold),
            (.italic, italic),
            (.code, code),
            (.strikethrough, strikethrough),
            (.highlight, highlight),
            (.numeric, numeric)
        ]
        defaultElements = pairs.filter({ (enabled, _) in
                                        enabledElements.contains(enabled) })
            .map({ (_, element) in
                    element })
    }
    
}
