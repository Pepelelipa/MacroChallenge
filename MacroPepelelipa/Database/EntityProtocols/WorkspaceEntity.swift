//
//  Workspace.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol WorkspaceEntity: class, ObservableEntity {
    var name: String { get set }
    var notebooks: [NotebookEntity] { get }
    var isEnabled: Bool { get set }
}
