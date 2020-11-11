//
//  NoteObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class NoteObject: NoteEntity, CloudKitObjectWrapper {

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
        didSet {
            if let data = title.toData() {
                coreDataNote.title = data
                cloudKitNote?.title.value = data
            }
            notifyObservers()
        }
    }
    var text: NSAttributedString {
        didSet {
            if let data = text.toData() {
                coreDataNote.text = data
                cloudKitNote?.text.value = data
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
    internal var cloudKitNote: CloudKitNote?
    var cloudKitObject: CloudKitEntity? {
        return cloudKitNote
    }

    internal init(in notebook: NotebookObject, from note: Note, and ckNote: CloudKitNote? = nil) {
        self.cloudKitNote = ckNote
        self.notebook = notebook
        self.coreDataNote = note
        self.title = note.title?.toAttributedString() ?? NSAttributedString()
        self.text = note.text?.toAttributedString() ?? NSAttributedString()
        
        notebook.notes.append(self)

        if let textBoxes = coreDataNote.textBoxes?.allObjects as? [TextBox] {
            textBoxes.forEach { (textBox) in
                let ckObject = ckNote?.textBoxes?.first(where: { $0.record["id"] == textBox.id?.uuidString }) as? CloudKitTextBox
                assert(ckObject != nil, "CloudKit textBox was null")
                _ = TextBoxObject(in: self, from: textBox, and: ckObject)
            }
        }
        if let images = coreDataNote.images?.allObjects as? [ImageBox] {
            images.forEach { (imageBox) in
                let ckObject = ckNote?.imageBoxes?.first(where: { $0.record["id"] == imageBox.id?.uuidString }) as? CloudKitImageBox
                assert(ckObject != nil, "CloudKit imageBox was null")
                _ = ImageBoxObject(in: self, for: imageBox, and: ckObject)
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
        children.append(contentsOf: textBoxes)
        children.append(contentsOf: images)
        
        return children
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
