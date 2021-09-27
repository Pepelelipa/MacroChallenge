//
//  NoteObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal class NoteObject: NoteEntity {

    func getID() throws -> UUID {
        if let id = coreDataNote.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    func getNotebook() throws -> NotebookEntity {
        if let notebook = notebook {
            return notebook
        }
        throw NotebookError.notebookWasNull
    }
    private weak var notebook: NotebookObject?

    public var title: NSAttributedString {
        get {
            return coreDataNote.title?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataNote.title = data
            }
            notifyObservers()
        }
    }
    var text: NSAttributedString {
        get {
            return coreDataNote.text?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataNote.text = data
            }
            notifyObservers()
        }
    }

    public internal(set) var textBoxes: [TextBoxEntity] = [] {
        didSet {
            notifyObservers()
        }
    }
    public internal(set) var images: [ImageBoxEntity] = [] {
        didSet {
            notifyObservers()
        }
    }

    private var observers: [EntityObserver] = []

    internal let coreDataNote: Note

    internal init(in notebook: NotebookObject?, from note: Note) {
        self.notebook = notebook
        self.coreDataNote = note
        
        if let notebook = notebook {
            notebook.notes.append(self)    
        }
        
        if let textBoxes = coreDataNote.textBoxes?.allObjects as? [TextBox] {
            textBoxes.forEach { (textBox) in
                _ = TextBoxObject(in: self, from: textBox)
            }
        }
        if let images = coreDataNote.images?.allObjects as? [ImageBox] {
            images.forEach { (imageBox) in
                _ = ImageBoxObject(in: self, from: imageBox)
            }
        }
    }

    internal func setNotebook(_ notebook: NotebookObject) {
        removeReferences()
        self.notebook = notebook
        notebook.notes.append(self)
    }

    func addObserver(_ observer: EntityObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: EntityObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    internal func removeReferences() {
        if let notebook = self.notebook,
           let index = notebook.notes.firstIndex(where: { $0 === self }) {
            notebook.notes.remove(at: index)
        }
    }

    internal func internalObjectsChanged() {
        notifyObservers()
    }
    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
