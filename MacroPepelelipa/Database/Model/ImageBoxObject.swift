//
//  ImageBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal struct ImageBoxObject: ImageBoxEntity {

    internal init(in note: NoteObject, coreDataObject: ImageBox) {
        self.note = note
        self.imagePath = coreDataObject.imagePath ?? ""
        self.width = coreDataObject.width
        self.height = coreDataObject.height
        self.x = coreDataObject.x
        self.y = coreDataObject.y
        self.z = coreDataObject.z

        note.images.append(self)
    }

    private weak var note: NoteObject?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.NoteWasNull
    }
    var imagePath: String
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    var z: Float
}
