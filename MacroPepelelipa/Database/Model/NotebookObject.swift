//
//  NotebookObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookObject: NotebookEntity {

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
        get {
            return coreDataNotebook.name ?? ""
        }
        set {
            coreDataNotebook.name = newValue
            notifyObservers()
        }
    }
    public var colorName: String {
        get {
            return coreDataNotebook.colorName ?? ""
        }
        set {
            coreDataNotebook.colorName = newValue
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
            
            let lenght = note.text.length
            
            note.text.enumerateAttribute(.font, 
                                         in: NSRange(0..<lenght), 
                                         options: .longestEffectiveRangeNotRequired) { (font, range, _) in
                
                if let font = font as? UIFont, 
                   font.pointSize == 32 || font.pointSize == 26 {
                    let text = note.text.attributedSubstring(from: range)
                    let headers = text.string.components(separatedBy: "\n")
                    
                    for header in headers {
                        let notebookIndexObject = NotebookIndexObject(index: header, note: note, isTitle: false)
                        indexes.append(notebookIndexObject)
                    }
                }
            }
        }
        return indexes
    }

    private var observers: [EntityObserver] = []

    internal let coreDataNotebook: Notebook
    
    internal init(in workspace: WorkspaceObject, from notebook: Notebook) {
        self.workspace = workspace
        self.coreDataNotebook = notebook
        
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
        try DataManager.shared().saveObjects(getSavable())
    }

    internal func getSavable() -> [PersistentEntity] {
        var children: [PersistentEntity] = [self]
        if let notes = notes as? [NoteObject] {
            for note in notes {
                children.append(contentsOf: note.getSavable())
            }
        }
        
        return children
    }

    internal func removeReferences() {
        if let workspace = self.workspace,
           let index = workspace.notebooks.firstIndex(where: { $0 === self }) {
            workspace.notebooks.remove(at: index)
        }
        for note in notes {
            if let note = note as? NoteObject {
                note.removeReferences()
            }
        }
    }

    internal func internalObjectsChanged() {
        notifyObservers()
    }
    private func notifyObservers() {
        workspace?.internalObjectsChanged()
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
