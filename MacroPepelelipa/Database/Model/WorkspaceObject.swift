//
//  WorkspaceObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class WorkspaceObject: WorkspaceEntity {

    func getID() throws -> UUID {
        if let id = coreDataObject.id {
            return id
        }
        throw ObservableError.idWasNull
    }

    public var name: String {
        didSet {
            coreDataObject.name = name
            notifyObservers()
        }
    }

    public var isEnabled: Bool {
        didSet {
            coreDataObject.isEnabled = isEnabled
            notifyObservers()
        }
    }

    public internal(set) var notebooks: [NotebookEntity] = [] {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers: [EntityObserver] = []

    internal let coreDataObject: Workspace

    internal init(from workspace: Workspace) {
        self.coreDataObject = workspace
        self.name = workspace.name ?? ""
        self.isEnabled = workspace.isEnabled
        
        if let notebooks = coreDataObject.notebooks?.array as? [Notebook] {
            notebooks.forEach { (notebook) in
                _ = NotebookObject(in: self, from: notebook)
            }
        }
    }

    func addObserver(_ observer: EntityObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: EntityObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func save() throws {
        try DataManager.shared().saveObjects()
    }

    internal func removeReferences() throws {
        for notebook in notebooks {
            if let notebook = notebook as? NotebookObject {
                try notebook.removeReferences()
            }
        }
    }

    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
