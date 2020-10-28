//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol NotebookEntity: class, ObservableEntity {
    var name: String { get set }
    var colorName: String { get set }
    var notes: [NoteEntity] { get }
    var indexes: [NotebookIndexEntity] { get }

    func getWorkspace() throws -> WorkspaceEntity
}
