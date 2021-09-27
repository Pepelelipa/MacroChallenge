//
//  ImageBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal class ImageBoxObject: ImageBoxEntity {

    func getID() throws -> UUID {
        if let id = coreDataImageBox.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    internal init(in note: NoteObject, from coreDataObject: ImageBox) {
        self.coreDataImageBox = coreDataObject
        self.note = note

        note.images.append(self)
    }

    private weak var note: NoteObject?
    func getNote() throws -> NoteEntity {
        if let note = note {
            return note
        }
        throw NoteError.noteWasNull
    }
    var imagePath: String {
        get {
            return coreDataImageBox.imagePath ?? ""
        }
        set {
            coreDataImageBox.imagePath = newValue
        }
    }
    var width: Float {
        get {
            return coreDataImageBox.width
        }
        set {
            coreDataImageBox.width = newValue
        }
    }
    var height: Float {
        get {
            return coreDataImageBox.height
        }
        set {
            coreDataImageBox.height = newValue
        }
    }
    var x: Float {
        get {
            return coreDataImageBox.x
        }
        set {
            coreDataImageBox.x = newValue
        }
    }
    var y: Float {
        get {
            return coreDataImageBox.y
        }
        set {
            coreDataImageBox.y = newValue
        }
    }
    var z: Float {
        get {
            return coreDataImageBox.z
        }
        set {
            coreDataImageBox.z = newValue
        }
    }

    internal let coreDataImageBox: ImageBox

    internal func removeReferences() {
        if let note = self.note,
           let index = note.images.firstIndex(where: { $0 === self }) {
            note.images.remove(at: index)
        }
    }
}
