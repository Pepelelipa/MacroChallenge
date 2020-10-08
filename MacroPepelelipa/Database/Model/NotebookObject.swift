//
//  NotebookObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class NotebookObject: NotebookEntity {

    func getWorkspace() throws -> WorkspaceEntity {
        if let workspace = workspace {
            return workspace
        }
        throw WorkspaceError.WorkspaceWasNull
    }

    var name: String
    private weak var workspace: WorkspaceEntity?
    var colorName: String

    var notes: [NoteEntity] = []
    var indexes: [NotebookIndexEntity] = []

    private var observers: [EntityObserver] = []

    internal init(name: String, workspace: WorkspaceEntity, colorName: String) {
        self.name = name
        self.workspace = workspace
        self.colorName = colorName
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
        #warning("Notebook isn't saving yet")
    }

    private func notifyObservers() {
        observers.forEach({$0.entityDidChangeTo(self)})
    }
}
