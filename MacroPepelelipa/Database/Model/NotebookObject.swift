//
//  NotebookObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import CloudKit

internal class NotebookObject: NotebookEntity, CloudKitObjectWrapper {

    func getID() throws -> UUID {
        if let id = coreDataNotebook.id {
            return id
        }
        throw ObservableError.idWasNull
    }

    private weak var workspace: WorkspaceObject?
    public func getWorkspace() throws -> WorkspaceEntity {
        if let workspace = workspace {
            return workspace
        }
        throw WorkspaceError.workspaceWasNull
    }

    public var name: String {
        didSet {
            coreDataNotebook.name = name
            notifyObservers()
        }
    }
    public var colorName: String {
        didSet {
            coreDataNotebook.colorName = colorName
            notifyObservers()
        }
    }

    public internal(set) var notes: [NoteEntity] = [] {
        didSet {
            notifyObservers()
        }
    }
    public var indexes: [NotebookIndexEntity] {
        var indexes: [NotebookIndexObject] = []
        for note in notes {
            indexes.append(NotebookIndexObject(index: note.title.string, note: note, isTitle: true))
            //TODO: get H1s
        }
        return indexes
    }

    private var observers: [EntityObserver] = []

    internal let coreDataNotebook: Notebook
    internal var cloudKitNotebook: CloudKitNotebook?
    var cloudKitObject: CloudKitEntity? {
        return cloudKitNotebook
    }


    internal init(in workspace: WorkspaceObject, from notebook: Notebook, and ckNotebook: CloudKitNotebook? = nil) {
        self.cloudKitNotebook = ckNotebook
        self.workspace = workspace
        self.coreDataNotebook = notebook
        self.name = notebook.name ?? ""
        self.colorName = notebook.colorName ?? ""
        
        workspace.notebooks.append(self)

        if let notes = coreDataNotebook.notes?.array as? [Note] {
            notes.forEach { (note) in
                _ = NoteObject(in: self, from: note)
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
        try DataManager.shared().saveObjects(getChildren())
    }

    internal func getChildren() -> [PersistentEntity] {
        var children: [PersistentEntity] = []
        children.append(contentsOf: notes)
        if let notes = notes as? [NoteObject] {
            for note in notes {
                children.append(contentsOf: note.getChildren())
            }
        }
        
        return children
    }

    internal func removeReferences() throws {
        if let workspace = self.workspace,
           let index = workspace.notebooks.firstIndex(where: { $0 === self }) {
            workspace.notebooks.remove(at: index)
        }
        for note in notes {
            if let note = note as? NoteObject {
                try note.removeReferences()
            }
        }
    }

    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
