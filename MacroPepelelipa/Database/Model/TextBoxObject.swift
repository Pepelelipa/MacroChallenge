//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal struct TextBoxObject: TextBoxEntity {
    weak var note: NoteEntity?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.NoteWasNull
    }
    var text: NSAttributedString
    var width: Float
    var heigth: Float
    var x: Float
    var y: Float
    var z: Float
}
