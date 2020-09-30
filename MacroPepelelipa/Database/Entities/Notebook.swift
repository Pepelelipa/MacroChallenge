//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreGraphics

internal class Notebook: NotebookEntity {
    var workspace: WorkspaceEntity
    var name: String
    var color: CGColor
    var notes: [NoteEntity] = []
    var indexes: [NotebookIndexEntity] {
        var indexes: [NotebookIndexEntity] = []
        for note in notes {
            indexes.append(NotebookIndex(index: note.title.string, note: note, isTitle: true))
        }
        return indexes
    }

    internal init(workspace: Workspace, name: String, color: CGColor) {
        self.workspace = workspace
        self.name = name
        self.color = color
        workspace.notebooks.append(self)
    }
}
