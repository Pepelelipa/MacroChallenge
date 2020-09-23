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
    
    override init() {
        markdownParser = MarkdownParser(color: UIColor(named: "Body") ?? .black)
        isShowingPlaceholder = false
        isBackspace = false
        placeholder = "Start writing here".localized()
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
        
        self.range = range
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isShowingPlaceholder {
            textView.attributedText = NSAttributedString(string: "")
            isShowingPlaceholder = false
        }
        return true
    }
}
