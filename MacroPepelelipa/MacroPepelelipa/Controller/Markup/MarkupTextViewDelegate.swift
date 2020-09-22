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
    private var text: String
    private var placeholder: String
    private var isShowingPlaceholder: Bool
    private var isBackspace: Bool
    private var range: NSRange?
    
    override init() {
        markdownParser = MarkdownParser()
        isShowingPlaceholder = false
        isBackspace = false
        placeholder = "#" + NSLocalizedString("Start writing here", comment: "")
        text = ""
    }
    
    public func parsePlaceholder(on textView: UITextView) {
        textView.font = markdownParser.font
        parseString(markdownString: placeholder)
        isShowingPlaceholder = true
        //        textView.textColor = UIColor(named: "Disabled")
    }
    
    private func parseString(markdownString: String) {}
    
    func textViewDidChange(_ textView: UITextView) {
        //        parseString(markdownString: text)
        //        markdownAttributesChanged?(markdownParser.parse(textView.attributedText), nil)
        if let range = range {
            textView.attributedText = markdownParser.parse(textView.attributedText, range: range, isBackspace: isBackspace)
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
            text = "# "
            parseString(markdownString: text)
            isShowingPlaceholder = false
        }
        return true
    }
}
