//
//  Note.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class Note: NoteEntity {
    var notebook: NotebookEntity
    var title: NSAttributedString
    var text: NSAttributedString
    var images: [ImageBoxEntity] = []
    var textBoxes: [TextBoxEntity] = []

    internal init(notebook: Notebook, title: NSAttributedString, text: NSAttributedString) {
        self.notebook = notebook
        self.title = title
        self.text = text
        notebook.notes.append(self)
    }
}
