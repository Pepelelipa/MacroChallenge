//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class Notebook: NotebookEntity {
    var workspace: WorkspaceEntity
    var name: String
    var color: UIColor
    var notes: [NoteEntity] = []

    internal init(workspace: Workspace, name: String, color: UIColor) {
        self.workspace = workspace
        self.name = name
        self.color = color
        workspace.notebooks.append(self)
    }
}
