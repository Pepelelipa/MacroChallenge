//
//  MarkupTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextViewDelegate: NSObject, UITextViewDelegate {
    
    private let markdownParser: MarkdownParser
    public var markdownAttributesChanged: ((NSAttributedString?, Error?) -> Void)?
    private var placeholder: String
    private var isShowingPlaceholder: Bool
    private var isBackspace: Bool
    private var range: NSRange?
    private var lastWrittenText: String
    
    override init() {
        markdownParser = MarkdownParser(color: UIColor(named: "Body") ?? .black)
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
        textView.textColor = UIColor(named: "Placeholder")
    }
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.attributedText.string.last == "\n" && MarkdownList.isList && !isBackspace {
            let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
            
            let attributedString = NSMutableAttributedString(string: "* ")
            MarkdownList.formatListStyle(
                attributedString,
                range: NSRange(location: 0, length: attributedString.length),
                level: 1
            )
            
            attributedText.append(attributedString)
            textView.attributedText = attributedText
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
        
        if MarkdownList.isList && lastWrittenText == "\n" && text == "\n" {
            MarkdownList.isList = false
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
}
