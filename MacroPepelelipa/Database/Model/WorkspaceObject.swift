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

    internal init(named name: String) {
        self.name = name
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
