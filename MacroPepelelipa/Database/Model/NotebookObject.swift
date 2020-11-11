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
        throw PersistentError.idWasNull
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
            cloudKitNotebook?.name.value = name
            notifyObservers()
        }
    }
    public var colorName: String {
        didSet {
            coreDataNotebook.colorName = colorName
            cloudKitNotebook?.colorName.value = colorName
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
    internal var cloudKitNotebook: CloudKitNotebook? {
        didSet {
            notes.forEach { note in
                let ckNote = cloudKitNotebook?.notes?.references.first(where: { $0.id.value == (try? note.getID())?.uuidString })
                (note as? NoteObject)?.cloudKitNote = ckNote
            }
        }
    }
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
                let ckObject = ckNotebook?.notes?.first(where: { $0.record["id"] == note.id?.uuidString }) as? CloudKitNote
                _ = NoteObject(in: self, from: note, and: ckObject)
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
        children.append(contentsOf: notes)
        if let notes = notes as? [NoteObject] {
            for note in notes {
                children.append(contentsOf: note.getSavable())
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
