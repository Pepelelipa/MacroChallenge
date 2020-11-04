//
//  MarkdownTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

internal class AppMarkdownTextViewDelegate: MarkdownTextViewDelegate {
    private var textDidChangeSelection: (() -> Void)?
    init(textDidChangeSelection: (() -> Void)? = nil) {
        self.textDidChangeSelection = textDidChangeSelection
    }

    override func textViewDidChangeSelection(_ textView: UITextView) {
        super.textViewDidChangeSelection(textView)
        textDidChangeSelection?()
    }
}
