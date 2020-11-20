//
//  NotesViewControllerConfiguration.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText
import Database

class NotesViewControllerConfiguration {
    
    private weak var boxViewReceiver: BoxViewReceiver?
    
    internal init(boxViewReceiver: BoxViewReceiver) {
        self.boxViewReceiver = boxViewReceiver
    }
    
    internal func configureNotesViewControllerContent(textView: MarkdownTextView, textField: MarkdownTextField, note: NoteEntity?, keyboardToolbar: MarkdownToolBar) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            textView.inputAccessoryView = keyboardToolbar
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            textView.inputAccessoryView = nil
        }

        if note?.title.string != "" {
            textField.attributedText = note?.title
        }
        if note?.text.string != "" {
            textView.attributedText = note?.text
        }
        for textBox in note?.textBoxes ?? [] {
            boxViewReceiver?.addTextBox(with: textBox)
        }
        for imageBox in note?.images ?? [] {
            boxViewReceiver?.addImageBox(with: imageBox)
        }
        
    }
}
