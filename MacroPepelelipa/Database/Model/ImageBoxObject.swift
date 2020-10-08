//
//  ImageBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal struct ImageBoxObject: ImageBoxEntity {
    weak var note: NoteEntity?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.NoteWasNull
    }
    var imagePath: String
    var width: Float
    var heigth: Float
    var x: Float
    var y: Float
    var z: Float
}
