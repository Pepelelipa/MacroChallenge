//
//  NoteObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class NoteObject: NoteEntity {

    func getID() throws -> UUID {
        if let id = coreDataObject.id {
            return id
        }
        throw ObservableError.idWasNull
    }

    func getNotebook() throws -> NotebookEntity {
        if let notebook = notebook {
            return notebook
        }
        throw NotebookError.notebookWasNull
    }
    private weak var notebook: NotebookObject?

    public var title: NSAttributedString {
        didSet {
            coreDataObject.title = title.toData()
            notifyObservers()
        }
    }
    var text: NSAttributedString {
        didSet {
            coreDataObject.text = text.toData()
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

    internal let coreDataObject: Note
    internal var cloudKitObject: CloudKitNote?

    internal init(in notebook: NotebookObject, from note: Note) {
        self.notebook = notebook
        self.coreDataObject = note
        self.title = note.title?.toAttributedString() ?? NSAttributedString()
        self.text = note.text?.toAttributedString() ?? NSAttributedString()
        
        notebook.notes.append(self)

        if let textBoxes = coreDataObject.textBoxes?.allObjects as? [TextBox] {
            textBoxes.forEach { (textBox) in
                _ = TextBoxObject(in: self, coreDataObject: textBox)
            }
        }
        if let images = coreDataObject.images?.allObjects as? [ImageBox] {
            images.forEach { (imageBox) in
                _ = ImageBoxObject(in: self, coreDataObject: imageBox)
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

    internal func removeReferences() throws {
        if let notebook = self.notebook,
           let index = notebook.notes.firstIndex(where: { $0 === self }) {
            notebook.notes.remove(at: index)
        }
    }

    private func notifyObservers() {
        observers.forEach({ $0.entityDidChangeTo(self) })
    }
}
