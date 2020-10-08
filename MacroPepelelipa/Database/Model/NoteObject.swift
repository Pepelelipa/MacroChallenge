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
    private weak var notebook: NotebookEntity?

    var title: NSAttributedString
    var text: NSAttributedString

    var images: [ImageBoxEntity] = []
    var textBoxes: [TextBoxEntity] = []

    private var observers: [EntityObserver] = []

    internal init() {
        title = NSAttributedString()
        text = NSAttributedString()
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
