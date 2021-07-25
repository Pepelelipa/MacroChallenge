//
//  RecentNotebookObject.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

internal class RecentNotebookObject: RecentNotebook {
    public var name: String {
        return notebook.name ?? "Notebook".localized()
    }
    public var colorName: String {
        return notebook.colorName ?? "nb0"
    }
    public var lastAccess: Date? {
        return notebook.lastAccess
    }
    public private(set) var notes: [RecentNote] = []
    
    public func getWorkspace() throws -> RecentWorkspace {
        if let workspace = workspace {
            return workspace
        }
        throw WorkspaceError.workspaceWasNull
    }
    private var workspace: RecentWorkspaceObject?
    private let notebook: Notebook
    
    internal init(in workspace: RecentWorkspaceObject, with notebook: Notebook) {
        self.workspace = workspace
        self.notebook = notebook
        self.workspace?.addNotebook(self)
    }
    
    internal init(with notebook: Notebook) {
        self.notebook = notebook
        if let workspace = notebook.workspace {
            self.workspace = RecentWorkspaceObject(from: workspace)
            self.workspace?.addNotebook(self)
        } else {
            self.workspace = nil
        }
    }
    
    internal func addNote(_ note: RecentNote) {
        notes.append(note)
    }
}
