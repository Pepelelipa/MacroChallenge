//
//  WorkspaceObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class WorkspaceObject: WorkspaceEntity {
    public var name: String {
        didSet {
            coreDataObject.name = name
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

        if let notebooks = coreDataObject.notebooks?.array as? [Notebook] {
            notebooks.forEach { (notebook) in
                self.notebooks.append(NotebookObject(in: self, from: notebook))
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

    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
