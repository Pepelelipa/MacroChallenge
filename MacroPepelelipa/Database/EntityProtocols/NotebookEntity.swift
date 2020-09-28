//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreGraphics

public protocol NotebookEntity: class {
    var name: String { get }
    var workspace: WorkspaceEntity { get }
    var color: CGColor { get }
    var notes: [NoteEntity] { get }
    var indexes: [NotebookIndexEntity] { get }
}
