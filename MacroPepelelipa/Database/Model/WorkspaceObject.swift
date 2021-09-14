//
//  WorkspaceObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class WorkspaceObject: WorkspaceEntity {

    func getID() throws -> UUID {
        if let id = coreDataWorkspace.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    public var name: String {
        get {
            return coreDataWorkspace.name ?? ""
        }
        set {
            coreDataWorkspace.name = newValue
            notifyObservers()
        }
    }

    public var isEnabled: Bool {
        get {
            return coreDataWorkspace.isEnabled
        }
        set {
            coreDataWorkspace.isEnabled = newValue
            notifyObservers()
        }
    }

    public internal(set) var notebooks: [NotebookEntity] = [] {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers: [EntityObserver] = []

    internal let coreDataWorkspace: Workspace

    internal init(from workspace: Workspace) {
        self.coreDataWorkspace = workspace
        
        if let notebooks = coreDataWorkspace.notebooks?.array as? [Notebook] {
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
        try DataManager.shared().saveObjects(getSavable())
    }

    internal func getSavable() -> [PersistentEntity] {
        var children: [PersistentEntity] = [self]
        if let notebooks = notebooks as? [NotebookObject] {
            for notebook in notebooks {
                children.append(contentsOf: notebook.getSavable())
            }
        }
        
        return children
    }

    internal func removeReferences() {
        for notebook in notebooks {
            if let notebook = notebook as? NotebookObject {
                notebook.removeReferences()
            }
        }
    }

    internal func internalObjectsChanged() {
        notifyObservers()
    }
    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
