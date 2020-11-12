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
    
    private weak var owner: UIViewController?
    
    internal init(owner: UIViewController) {
        self.owner = owner
    }
    
    internal func saveNote(note: inout NoteEntity?, textField: MarkdownTextField, textView: MarkdownTextView, textBoxes: Set<TextBoxView>, imageBoxes: Set<ImageBoxView>) {
        do {
            guard let note = note else {
                return
            }
            if textField.text?.replacingOccurrences(of: " ", with: "") != "" {
                note.title = textField.attributedText ?? NSAttributedString()
            }
            if textView.text?.replacingOccurrences(of: " ", with: "") != "" {
                note.text = textView.attributedText ?? NSAttributedString()
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
            try note.save()
            
            let defaults = UserDefaults.standard
            
            let notebook = try note.getNotebook()
            let workspace = try notebook.getWorkspace()
            
            let notebookID = try notebook.getID()
            let workspaceID = try workspace.getID()
            
            defaults.setValue(notebookID, forKey: "LastNotebookID")
            defaults.setValue(workspaceID, forKey: "LastWorkspaceID")
        } catch {
            let alertController = UIAlertController(
                title: "Error saving the notebook".localized(),
                message: "The database could not save the notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The Notebook could not be saved".localized())
            owner?.present(alertController, animated: true, completion: nil)
        }
    }
}
