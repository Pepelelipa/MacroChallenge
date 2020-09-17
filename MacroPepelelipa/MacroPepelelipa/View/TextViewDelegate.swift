//
//  TextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {

    var renderer: MarkupRenderer
    var text: String

    init(renderer: MarkupRenderer) {
        self.renderer = renderer
        self.text = ""
    }

    func render(on textView: UITextView) {
        textView.attributedText = renderer.render(text: self.text)
    }

    func textViewDidChange(_ textView: UITextView) {
        render(on: textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            self.text.removeLast()
        } else {
            self.text.append(text)
        }
        return true
    }
    
}
