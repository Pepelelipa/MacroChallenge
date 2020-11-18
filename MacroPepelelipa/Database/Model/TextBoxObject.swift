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
        get {
            return coreDataTextBox.text?.toAttributedString() ?? (cloudKitTextBox?.text.value as Data?)?.toAttributedString() ?? NSAttributedString()
        }
        set {
            if let data = newValue.toData() {
                coreDataTextBox.text = data
                cloudKitTextBox?.text.value = NSData(data: data)
            }
        }
    }
    public var width: Float {
        get {
            return coreDataTextBox.width
        }
        set {
            coreDataTextBox.width = newValue
            cloudKitTextBox?.width.value = Double(newValue)
        }
    }
    public var height: Float {
        get {
            return coreDataTextBox.width
        }
        set {
            coreDataTextBox.height = newValue
            cloudKitTextBox?.height.value = Double(newValue)
        }
    }
    public var x: Float {
        get {
            return coreDataTextBox.x
        }
        set {
            coreDataTextBox.x = newValue
            cloudKitTextBox?.x.value = Double(newValue)
        }
    }
    public var y: Float {
        get {
            return coreDataTextBox.y
        }
        set {
            coreDataTextBox.y = newValue
            cloudKitTextBox?.y.value = Double(newValue)
        }
    }
    public var z: Float {
        get {
            return coreDataTextBox.z
        }
        set {
            coreDataTextBox.z = newValue
            cloudKitTextBox?.z.value = Double(newValue)
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
