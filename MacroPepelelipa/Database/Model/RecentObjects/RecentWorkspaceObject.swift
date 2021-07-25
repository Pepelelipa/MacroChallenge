//
//  RecentWorkspaceObject.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

internal class RecentWorkspaceObject: RecentWorkspace {
    public var name: String {
        return workspace.name ?? "Workspace".localized()
    }
    public private(set) var notebooks: [RecentNotebook] = []
    
    private let workspace: Workspace
    
    internal init(from workspace: Workspace) {
        self.workspace = workspace
        if let notebooks = (workspace.notebooks?.array) as? [Notebook] {
            notebooks.forEach({
                _ = RecentNotebookObject(in: self, with: $0)
            })
        }
    }
    
    internal func addNotebook(_ notebook: RecentNotebook) {
        notebooks.append(notebook)
    }
}
