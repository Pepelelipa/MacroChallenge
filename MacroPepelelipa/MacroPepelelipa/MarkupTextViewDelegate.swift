//
//  MarkupTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextViewDelegate: NSObject, UITextViewDelegate {
    
    private var renderer: MarkupRenderer
    private var text: String
    
    init(renderer: MarkupRenderer) {
        self.renderer = MarkupRenderer(baseFont: .systemFont(ofSize: 16))
        self.text = ""
    }
    
    private func render(on textView: UITextView) {
        textView.attributedText = renderer.render(text: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        render(on: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let char = text.cString(using: String.Encoding.utf8) else {
            return false
        }
        
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            self.text.removeLast()
        } else {
            self.text.append(text)
        }
        return true
    }
}
