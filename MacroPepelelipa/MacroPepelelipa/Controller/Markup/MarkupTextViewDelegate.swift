//
//  MarkupTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian, 
//             Leonardo Amorim de Oliveira and 
//             Pedro Henrique Guedes Silveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextViewDelegate: NSObject, UITextViewDelegate {
    
    private let markdownParser: MarkdownParser
    private let markdownEditor: MarkdownEditor
    public var markdownAttributesChanged: ((NSAttributedString?, Error?) -> Void)?
    private var placeholder: String
    private var isShowingPlaceholder: Bool
    private var isBackspace: Bool
    private var range: NSRange?
    private var lastWrittenText: String

    internal private(set) var observers: [TextEditingDelegateObserver] = []
    
    func addObserver(_ observer: TextEditingDelegateObserver) {
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: TextEditingDelegateObserver) {
        if let index = self.observers.firstIndex(where: { $0 === observer }) {
            self.observers.remove(at: index)
        }
    }

    override init() {
        markdownParser = MarkdownParser(color: .bodyColor ?? .black)
        markdownEditor = MarkdownEditor(markdownParser: markdownParser)
        isShowingPlaceholder = false
        isBackspace = false
        placeholder = "Start writing here".localized()
        lastWrittenText = ""
    }
    
    /**
     This method displays the placeholder with the correct color on an UITextView.
     
     - Parameter textView: The UITextView on which the placeholder will be displayed.
     */
    public func parsePlaceholder(on textView: UITextView) {
        textView.attributedText = NSAttributedString(string: placeholder)
        textView.font = markdownParser.font
        isShowingPlaceholder = true
        textView.textColor = .placeholderColor
    }
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.attributedText.string.last == "\n" && !isBackspace {
            continueBulletList(on: textView)
            continueNumericList(on: textView)
            continueQuote(on: textView)
        }
        
        if let range = range {
            markdownAttributesChanged?(markdownParser.parse(textView.attributedText, range: range, isBackspace: isBackspace), nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let char = text.cString(using: String.Encoding.utf8) else {
            return false
        }
        
        let backspace = strcmp(char, "\\b")
        if backspace == -92 {
            self.isBackspace = true
        } else {
            self.isBackspace = false
        }
        
        if text == "\n" {
            markdownParser.font = MarkdownParser.defaultFont
            MarkupToolBar.headerStyle = .h1
            observers.forEach({
                $0.textReceivedEnter()
            })
            
            if lastWrittenText == "\n" {
                if MarkdownList.isList {
                    MarkdownList.isList = false
                }
                
                if MarkdownNumeric.isNumeric {
                    MarkdownNumeric.isNumeric = false
                }
                
                if MarkdownQuote.isQuote {
                    MarkdownQuote.isQuote = false
                }
            }
        }
        
        lastWrittenText = text
        
        self.range = range
        
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isShowingPlaceholder {
            textView.attributedText = NSAttributedString(string: "")
            textView.textColor = markdownParser.color
            isShowingPlaceholder = false
        }
        return true
    }
    
    /**
     This method continues to add a Bullet List on the UITextView if a Bullet List was already started.
     
     - Parameter textView: The UITextView on which will be added the Bullet List.
     */
    private func continueBulletList(on textView: UITextView) {
        if MarkdownList.isList {
            markdownEditor.addBulletList(on: textView, true)
        }
    }
    
    /**
     This method continues to add a Numeric List on the UITextView if a Numeric List was already started.
     
     - Parameter textView: The UITextView on which will be added the Numeric List.
     */
    private func continueNumericList(on textView: UITextView) {
        if MarkdownNumeric.isNumeric {
            MarkdownNumeric.updateNumber(isBackspace: isBackspace)
            markdownEditor.addNumericList(on: textView, true)
        }
    }
    
    /**
     This method continues to add a Quotes on the UITextView if a Quote was already started.
     
     - Parameter textView: The UITextView on which will be added the Quote.
     */
    private func continueQuote(on textView: UITextView) {
        if MarkdownQuote.isQuote {
            markdownEditor.addQuote(on: textView, true)
        }
    }
    
    /**
     This method adds a type of list to the UITextView and calls the editor's formatting methods.
     
     - Parameters:
        - textView: The UITextView that will be formatted.
        - type: A case of the ListStyle enum indicating the type of list to be displayed.
        - lineCleared: A boolean indicating if a line break is needed or not.
     */
    public func addList(on textView: UITextView, type: ListStyle, _ lineCleared: Bool) {
        switch type {
        case .bullet:
            markdownEditor.addBulletList(on: textView, lineCleared)
        case .numeric:
            markdownEditor.addNumericList(on: textView, lineCleared)
        case .quote:
            markdownEditor.addQuote(on: textView, lineCleared)
        }
    }
    
    /**
     This method calls the editor's method to add italic attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func addItalic(on textView: UITextView) {
        markdownEditor.addItalic(on: textView)
    }
    
    /**
     This method calls the editor's method to add bold attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func addBold(on textView: UITextView) {
        markdownEditor.addBold(on: textView)
    }
    
    /**
     This method calls the editor's method to add bold and italic attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func addBoldItalic(on textView: UITextView) {
        markdownEditor.addBoldItalic(on: textView)
    }
    
    /**
     This method calls the editor's method to remove all format attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func removesFormatAttributes(on textView: UITextView) {
        markdownEditor.removesFormatAttributes(on: textView)
    }
    
    /**
     This method calls the editor's method to add header attributes on the UITextView based on the selected range and the chosen style.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
        - style: A case of the HeaderStyle enum declaring the chosen style.
     */
    public func addHeader(on textView: UITextView, with style: HeaderStyle) {
        markdownEditor.addHeader(on: textView, with: style)
    }
    
    /**
     This method clears indicators on a line on the UITextView.
     
     - Parameter textView: The UITextView which text will be checked and changed in case of any found indicators.
     
     - Returns: True if any characters were cleared, false if none was cleared.
     */
    public func clearIndicatorCharacters(_ textView: UITextView) -> Bool {
        return markdownEditor.clearIndicatorCharacters(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        observers.forEach({
            $0.textEditingDidBegin()
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        observers.forEach({
            $0.textEditingDidEnd()
        })
    }
}
