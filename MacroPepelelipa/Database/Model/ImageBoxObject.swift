//
//  ImageBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal class ImageBoxObject: ImageBoxEntity, CloudKitObjectWrapper {

    func getID() throws -> UUID {
        if let id = coreDataImageBox.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    internal init(in note: NoteObject, for coreDataObject: ImageBox, and cloudKitImageBox: CloudKitImageBox?) {
        self.cloudKitImageBox = cloudKitImageBox
        self.coreDataImageBox = coreDataObject
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
        throw NoteError.noteWasNull
    }
    var imagePath: String {
        didSet {
            coreDataImageBox.imagePath = imagePath
        }
    }
    var width: Float {
        didSet {
            coreDataImageBox.width = width
        }
    }
    var height: Float {
        didSet {
            coreDataImageBox.height = height
        }
    }
    var x: Float {
        didSet {
            coreDataImageBox.x = x
        }
    }
    var y: Float {
        didSet {
            coreDataImageBox.y = y
        }
    }
    var z: Float {
        didSet {
            coreDataImageBox.z = z
        }
    }

    internal let coreDataImageBox: ImageBox
    internal var cloudKitImageBox: CloudKitImageBox?
    var cloudKitObject: CloudKitEntity? {
        return cloudKitImageBox
    }

    internal func removeReferences() throws {
        if let note = self.note,
           let index = note.images.firstIndex(where: { $0 === self }) {
            note.images.remove(at: index)
        }
    }
}
