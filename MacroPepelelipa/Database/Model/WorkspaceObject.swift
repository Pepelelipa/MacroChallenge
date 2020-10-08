//
//  WorkspaceObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class WorkspaceObject: WorkspaceEntity {
    var name: String

    var notebooks: [NotebookEntity] = []
    
    private var observers: [EntityObserver] = []

    internal private(set) var coreDataObject: Workspace {
        didSet {
            name = coreDataObject.name ?? ""
            notebooks.removeAll()
            if let notebooks = coreDataObject.notebooks?.array as? [Notebook] {
                notebooks.forEach { (notebook) in
                    self.notebooks.append(NotebookObject(from: notebook))
                }
            }
        }
    }

    internal init(from workspace: Workspace) {
        self.coreDataObject = workspace
        self.name = workspace.name ?? ""
    }
    internal init(named name: String, coreDataObject workspace: Workspace) {
        self.name = name
        
        workspace.name = name

        self.coreDataObject = workspace
    }

    func addObserver(_ observer: EntityObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: EntityObserver) {
        if let index = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: index)
        }
    }

    func save() throws {
        #warning("Workspace isn't saving yet.")
    }

    private func notifyObservers() {
        observers.forEach({$0.entityDidChangeTo(self)})
    }
}
