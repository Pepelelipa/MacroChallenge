//
//  WorkspaceObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class WorkspaceObject: WorkspaceEntity, CloudKitObjectWrapper {

    func getID() throws -> UUID {
        if let id = coreDataWorkspace.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    public var name: String {
        get {
            return coreDataWorkspace.name ?? cloudKitWorkspace?.name.value ?? ""
        }
        set {
            coreDataWorkspace.name = newValue
            cloudKitWorkspace?.name.value = newValue
            notifyObservers()
        }
    }

    public var isEnabled: Bool {
        get {
            return coreDataWorkspace.isEnabled
        }
        set {
            coreDataWorkspace.isEnabled = newValue
            cloudKitWorkspace?.isEnabled.value = newValue ? 1 : 0
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
    internal var cloudKitWorkspace: CloudKitWorkspace? {
        didSet {
            notebooks.forEach({ notebook in
                let ckNotebook = cloudKitWorkspace?.notebooks?.references.first(where: { $0.id.value == (try? notebook.getID())?.uuidString })
                (notebook as? NotebookObject)?.cloudKitNotebook = ckNotebook
            })
        }
    }

    internal var cloudKitObject: CloudKitEntity? {
        return cloudKitWorkspace
    }

    internal init(from workspace: Workspace, and ckWorkspace: CloudKitWorkspace? = nil) {
        self.cloudKitWorkspace = ckWorkspace
        self.coreDataWorkspace = workspace
        
        if let notebooks = coreDataWorkspace.notebooks?.array as? [Notebook] {
            notebooks.forEach { (notebook) in
                let ckObject = ckWorkspace?.notebooks?.first(where: { $0.record["id"] == notebook.id?.uuidString }) as? CloudKitNotebook
                _ = NotebookObject(in: self, from: notebook, and: ckObject)
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

    internal func removeReferences() throws {
        for notebook in notebooks {
            if let notebook = notebook as? NotebookObject {
                try notebook.removeReferences()
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
