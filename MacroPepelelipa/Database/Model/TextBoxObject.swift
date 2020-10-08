//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal struct TextBoxObject: TextBoxEntity {

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
        throw NoteError.NoteWasNull
    }
    public var text: NSAttributedString
    public var width: Float
    public var height: Float
    public var x: Float
    public var y: Float
    public var z: Float

    internal let coreDataObject: TextBox
}
