//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal class TextBoxObject: TextBoxEntity {

    func getID() throws -> UUID {
        if let id = coreDataTextBox.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    internal init(in note: NoteObject, from coreDataObject: TextBox) {
        self.note = note
        self.coreDataTextBox = coreDataObject

        note.textBoxes.append(self)
    }

    private weak var note: NoteObject?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.noteWasNull
    }

    public var text: NSAttributedString {
        get {
            return coreDataTextBox.text?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataTextBox.text = data
            }
        }
    }
    public var width: Float {
        get {
            return coreDataTextBox.width
        }
        set {
            coreDataTextBox.width = newValue
        }
    }
    public var height: Float {
        get {
            return coreDataTextBox.width
        }
        set {
            coreDataTextBox.height = newValue
        }
    }
    public var x: Float {
        get {
            return coreDataTextBox.x
        }
        set {
            coreDataTextBox.x = newValue
        }
    }
    public var y: Float {
        get {
            return coreDataTextBox.y
        }
        set {
            coreDataTextBox.y = newValue
        }
    }
    public var z: Float {
        get {
            return coreDataTextBox.z
        }
        set {
            coreDataTextBox.z = newValue
        }
    }

    internal let coreDataTextBox: TextBox

    internal func removeReferences() {
        if let note = self.note,
           let index = note.textBoxes.firstIndex(where: { $0 === self }) {
            note.textBoxes.remove(at: index)
        }
    }
}
