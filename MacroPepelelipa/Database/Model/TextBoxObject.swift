//
//  TextBoxObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal class TextBoxObject: TextBoxEntity, CloudKitObjectWrapper {

    func getID() throws -> UUID {
        if let id = coreDataTextBox.id {
            return id
        }
        throw PersistentError.idWasNull
    }

    internal init(in note: NoteObject, from coreDataObject: TextBox, and ckTextBox: CloudKitTextBox? = nil) {
        self.cloudKitTextBox = ckTextBox
        self.note = note
        self.coreDataTextBox = coreDataObject

        self.text = coreDataObject.text?.toAttributedString() ?? NSAttributedString()
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
            if let data = text.toData() {
                coreDataTextBox.text = data
                cloudKitTextBox?.text.value = data
            }
        }
    }
    public var width: Float {
        didSet {
            coreDataTextBox.width = width
            cloudKitTextBox?.width.value = Double(width)
        }
    }
    public var height: Float {
        didSet {
            coreDataTextBox.height = height
            cloudKitTextBox?.height.value = Double(height)
        }
    }
    public var x: Float {
        didSet {
            coreDataTextBox.x = x
            cloudKitTextBox?.x.value = Double(x)
        }
    }
    public var y: Float {
        didSet {
            coreDataTextBox.y = y
            cloudKitTextBox?.y.value = Double(y)
        }
    }
    public var z: Float {
        didSet {
            coreDataTextBox.z = z
            cloudKitTextBox?.z.value = Double(z)
        }
    }

    internal let coreDataTextBox: TextBox
    internal var cloudKitTextBox: CloudKitTextBox?
    var cloudKitObject: CloudKitEntity? {
        return cloudKitTextBox
    }

    internal func removeReferences() throws {
        if let note = self.note,
           let index = note.textBoxes.firstIndex(where: { $0 === self }) {
            note.textBoxes.remove(at: index)
        }
    }
}
