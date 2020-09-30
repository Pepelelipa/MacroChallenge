//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol NotebookEntity: class {
    var name: String { get }
    var workspace: WorkspaceEntity { get }
    var colorName: String { get }
    var notes: [NoteEntity] { get }
    var indexes: [NotebookIndexEntity] { get }
}
