//
//  Workspace.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class Workspace: WorkspaceEntity {
    var name: String
    var notebooks: [NotebookEntity] = []

    init(name: String) {
        self.name = name
    }
}
