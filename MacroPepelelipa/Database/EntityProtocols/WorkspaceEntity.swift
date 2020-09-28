//
//  Workspace.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol WorkspaceEntity: class {
    var name: String { get }
    var notebooks: [NotebookEntity] { get }
}
