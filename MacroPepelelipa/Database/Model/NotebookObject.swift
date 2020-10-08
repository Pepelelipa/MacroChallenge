//
//  NotebookObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class NotebookObject: NotebookEntity {

    private weak var workspace: WorkspaceEntity?
    func getWorkspace() throws -> WorkspaceEntity {
        if let workspace = workspace {
            return workspace
        }
        throw WorkspaceError.WorkspaceWasNull
    }

    var name: String
    var colorName: String

    var notes: [NoteEntity] = []
    var indexes: [NotebookIndexEntity] = []

    private var observers: [EntityObserver] = []

    internal private(set) var coreDataObject: Notebook {
        didSet {
            name = coreDataObject.name ?? ""
            colorName = coreDataObject.colorName ?? ""
            notes.removeAll()
            if let notes = coreDataObject.notes?.array as? [Note] {
                notes.forEach { (note) in
                    //TODO: NoteObject constructor from Note
                }
            }
        }
    }

    internal init(from notebook: Notebook) {
        self.coreDataObject = notebook
        self.name = notebook.name ?? ""
        self.colorName = notebook.colorName ?? ""
    }

    internal init(name: String, workspace: WorkspaceObject, colorName: String, coreDataObject notebook: Notebook) {
        self.name = name
        self.workspace = workspace
        self.colorName = colorName

        notebook.name = name
        notebook.workspace = workspace.coreDataObject
        notebook.colorName = colorName
        
        self.coreDataObject = notebook
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
