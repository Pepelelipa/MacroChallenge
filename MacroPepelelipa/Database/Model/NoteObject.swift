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
        get {
            return coreDataNote.title?.toAttributedString() ?? (cloudKitNote?.title.value as Data?)?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataNote.title = data
                cloudKitNote?.title.value = NSData(data: data)
            }
            notifyObservers()
        }
    }
    var text: NSAttributedString {
        get {
            return coreDataNote.text?.toAttributedString() ?? (cloudKitNote?.text.value as Data?)?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataNote.text = data
                cloudKitNote?.text.value = NSData(data: data)
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
    internal var cloudKitNote: CloudKitNote? {
        didSet {
            textBoxes.forEach({ textBox in
                let ckTextBox = cloudKitNote?.textBoxes?.references.first(where: { $0.id.value == (try? textBox.getID())?.uuidString })
                (textBox as? TextBoxObject)?.cloudKitTextBox = ckTextBox
            })

            images.forEach({ imageBox in
                let ckImageBox = cloudKitNote?.imageBoxes?.references.first(where: { $0.id.value == (try? imageBox.getID())?.uuidString })
                (imageBox as? ImageBoxObject)?.cloudKitImageBox = ckImageBox
            })
        }
    }
    var cloudKitObject: CloudKitEntity? {
        return cloudKitNote
    }

    internal init(in notebook: NotebookObject, from note: Note, and ckNote: CloudKitNote? = nil) {
        self.cloudKitNote = ckNote
        self.notebook = notebook
        self.coreDataNote = note
        
        notebook.notes.append(self)

        if let textBoxes = coreDataNote.textBoxes?.allObjects as? [TextBox] {
            textBoxes.forEach { (textBox) in
                let ckObject = ckNote?.textBoxes?.first(where: { $0.record["id"] == textBox.id?.uuidString }) as? CloudKitTextBox
                _ = TextBoxObject(in: self, from: textBox, and: ckObject)
            }
        }
        if let images = coreDataNote.images?.allObjects as? [ImageBox] {
            images.forEach { (imageBox) in
                let ckObject = ckNote?.imageBoxes?.first(where: { $0.record["id"] == imageBox.id?.uuidString }) as? CloudKitImageBox
                _ = ImageBoxObject(in: self, from: imageBox, and: ckObject)
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
        children.append(contentsOf: textBoxes)
        children.append(contentsOf: images)
        
        return children
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
