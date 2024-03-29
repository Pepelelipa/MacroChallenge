//
//  NoteContentHandler.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import MarkdownText

internal class NoteContentHandler {
    
    internal func saveNote(note: inout NoteEntity?, textField: MarkdownTextField, textView: MarkdownTextView, textBoxes: Set<TextBoxView>, imageBoxes: Set<ImageBoxView>) {
        do {
            guard let note = note else {
                return
            }
            if textField.text?.replacingOccurrences(of: " ", with: "") != "" {
                note.title = textField.attributedText ?? NSAttributedString()
            }

            if textView.text.replacingOccurrences(of: " ", with: "") != "" {
                note.text = textView.attributedText ?? NSAttributedString()
            } else {
                note.text = NSAttributedString()
            }

            for textBox in textBoxes where textBox.frame.origin.x != 0 && textBox.frame.origin.y != 0 {
                if let entity = note.textBoxes.first(where: { $0 === textBox.entity }) {
                    entity.text = textBox.markupTextView.attributedText
                    entity.x = Float(textBox.frame.origin.x)
                    entity.y = Float(textBox.frame.origin.y)
                    entity.z = Float(textBox.layer.zPosition)
                    entity.width = Float(textBox.frame.width)
                    entity.height = Float(textBox.frame.height)
                }
            }
            
            for imageBox in imageBoxes where imageBox.frame.origin.x != 0 && imageBox.frame.origin.y != 0 {
                if let entity = note.images.first(where: { $0 === imageBox.entity }) {
                    entity.x = Float(imageBox.frame.origin.x)
                    entity.y = Float(imageBox.frame.origin.y)
                    entity.z = Float(imageBox.layer.zPosition)
                    entity.width = Float(imageBox.frame.width)
                    entity.height = Float(imageBox.frame.height)
                }
            }
        }
    }
}
