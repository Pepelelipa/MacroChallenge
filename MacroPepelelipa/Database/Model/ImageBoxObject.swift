//
//  ImageBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal class ImageBoxObject: ImageBoxEntity, CloudKitEntity {
    internal static let recordType: String = "ImageBox"
    internal lazy var record: CKRecord = .from(self)

    internal init(in note: NoteObject, coreDataObject: ImageBox) {
        self.note = note
        self.coreDataObject = coreDataObject

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
            coreDataObject.imagePath = imagePath
        }
    }
    var width: Float {
        didSet {
            coreDataObject.width = width
        }
    }
    var height: Float {
        didSet {
            coreDataObject.height = height
        }
    }
    var x: Float {
        didSet {
            coreDataObject.x = x
        }
    }
    var y: Float {
        didSet {
            coreDataObject.y = y
        }
    }
    var z: Float {
        didSet {
            coreDataObject.z = z
        }
    }

    internal let coreDataObject: ImageBox

    internal func removeReferences() throws {
        if let note = self.note,
           let index = note.images.firstIndex(where: { $0 === self }) {
            note.images.remove(at: index)
        }
    }
}
