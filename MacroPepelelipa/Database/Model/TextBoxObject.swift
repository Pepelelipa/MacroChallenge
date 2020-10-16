//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal class TextBoxObject: TextBoxEntity {

    internal init(in note: NoteObject, coreDataObject: TextBox) {
        self.note = note
        self.coreDataObject = coreDataObject

        self.text = coreDataObject.text ?? NSAttributedString()
        self.width = coreDataObject.width
        self.height = coreDataObject.height
        self.x = coreDataObject.x
        self.y = coreDataObject.y
        self.z = coreDataObject.z

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
        didSet {
            coreDataObject.text = text
        }
    }
    public var width: Float {
        didSet {
            coreDataObject.width = width
        }
    }
    public var height: Float {
        didSet {
            coreDataObject.height = height
        }
    }
    public var x: Float {
        didSet {
            coreDataObject.x = x
        }
    }
    public var y: Float {
        didSet {
            coreDataObject.y = y
        }
    }
    public var z: Float {
        didSet {
            coreDataObject.z = z
        }
    }

    internal let coreDataObject: TextBox
}
