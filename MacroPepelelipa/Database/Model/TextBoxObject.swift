//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal struct TextBoxObject: TextBoxEntity {

    internal init(in note: NoteEntity, coreDataObject: TextBox) {
        self.note = note
        self.text = coreDataObject.text ?? NSAttributedString()
        self.width = coreDataObject.width
        self.height = coreDataObject.height
        self.x = coreDataObject.x
        self.y = coreDataObject.y
        self.z = coreDataObject.z
    }

    weak var note: NoteEntity?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.NoteWasNull
    }
    var text: NSAttributedString
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    var z: Float
}
