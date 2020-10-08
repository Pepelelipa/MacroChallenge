//
//  NoteObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//


internal class NoteObject: NoteEntity {

    func getNotebook() throws -> NotebookEntity {
        if let notebook = notebook {
            return notebook
        }
        throw NotebookError.NotebookWasNull
    }
    private weak var notebook: NotebookObject?

    public var title: NSAttributedString {
        didSet {
            coreDataObject.title = title
            notifyObservers()
        }
    }
    var text: NSAttributedString {
        didSet {
            coreDataObject.text = text
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

    internal private(set) var coreDataObject: Note {
        didSet {
            self.title = coreDataObject.title ?? NSAttributedString()
            self.text = coreDataObject.text ?? NSAttributedString()

            textBoxes.removeAll()
            if let textBoxes = coreDataObject.textBoxes?.allObjects as? [TextBox] {
                textBoxes.forEach { (textBox) in
                    self.textBoxes.append(TextBoxObject(in: self, coreDataObject: textBox))
                }
            }

            images.removeAll()
            if let images = coreDataObject.images?.allObjects as? [ImageBox] {
                images.forEach { (imageBox) in
                    self.images.append(ImageBoxObject(in: self, coreDataObject: imageBox))
                }
            }
        }
    }

    internal init(in notebook: NotebookObject, from note: Note) {
        self.notebook = notebook
        self.coreDataObject = note
        self.title = note.title ?? NSAttributedString()
        self.text = note.text ?? NSAttributedString()
        
        notebook.notes.append(self)
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
        #warning("Note isn't saving yet")
    }

    private func notifyObservers() {
        observers.forEach({$0.entityDidChangeTo(self)})
    }

}
