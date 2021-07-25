//
//  RecentNoteObject.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

internal class RecentNoteObject: RecentNote {
    var title: NSAttributedString {
        return note.title?.toAttributedString() ?? NSAttributedString(string: "Title".localized())
    }
    var text: NSAttributedString {
        return note.text?.toAttributedString() ?? NSAttributedString(string: "Text".localized())
    }
    
    func getNotebook() throws -> RecentNotebook {
        if let notebook = notebook {
            return notebook
        }
        throw NotebookError.notebookWasNull
    }
    
    private var notebook: RecentNotebookObject?
    private let note: Note
    
    init(in notebook: RecentNotebookObject, with note: Note) {
        self.notebook = notebook
        self.note = note
        self.notebook?.addNote(self)
    }
}
