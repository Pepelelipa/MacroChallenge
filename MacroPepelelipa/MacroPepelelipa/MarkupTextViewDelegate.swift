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

    override init() {
        markdownParser = MarkdownParser()
        text = ""
    }
        
    private func parseString(markdownString: String) {
        markdownAttributesChanged?(markdownParser.parse(markdownString), nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        parseString(markdownString: text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let char = text.cString(using: String.Encoding.utf8) else {
            return false
        }
        
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 && !self.text.isEmpty {
            self.text.removeLast()
        } else {
            self.text.append(text)
        }
        return true
    }
}
