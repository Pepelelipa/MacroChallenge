//
//  NotebookObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class NotebookObject: NotebookEntity {

    private weak var workspace: WorkspaceObject?
    func getWorkspace() throws -> WorkspaceEntity {
        if let workspace = workspace {
            return workspace
        }
        throw WorkspaceError.WorkspaceWasNull
    }

    var name: String
    var colorName: String

    var notes: [NoteEntity] = []
    var indexes: [NotebookIndexEntity] {
        var indexes: [NotebookIndexObject] = []
        for note in notes {
            indexes.append(NotebookIndexObject(index: note.title.string, note: note, isTitle: true))
            //TODO: get the H1 texts from note
        }
        return indexes
    }

    private var observers: [EntityObserver] = []

    internal private(set) var coreDataObject: Notebook {
        didSet {
            name = coreDataObject.name ?? ""
            colorName = coreDataObject.colorName ?? ""
            
            notes.removeAll()
            if let notes = coreDataObject.notes?.array as? [Note] {
                notes.forEach { (note) in
                    self.notes.append(NoteObject(in: self, from: note))
                }
            }
        }
    }

    internal init(in workspace: WorkspaceObject, from notebook: Notebook) {
        self.workspace = workspace
        self.coreDataObject = notebook
        self.name = notebook.name ?? ""
        self.colorName = notebook.colorName ?? ""
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
