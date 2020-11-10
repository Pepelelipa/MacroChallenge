//
//  CloudKitNote.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitNote: CloudKitEntity {
    internal static let recordType: String = "Note"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var title: DataProperty<Data> = DataProperty(record: record, key: "title")
    internal private(set) lazy var text: DataProperty<Data> = DataProperty(record: record, key: "text")
    internal private(set) var notebook: ReferenceField<CloudKitNotebook>?
    internal private(set) var textBoxes: ReferenceList<CloudKitTextBox>?
    internal private(set) var imageBoxes: ReferenceList<CloudKitImageBox>?

    init(from note: NoteObject) {
        let record = CKRecord(recordType: CloudKitNote.recordType)
        record["id"] = try? note.getID().uuidString
        record["title"] = note.title.toData()
        record["text"] = note.text.toData()
        self.record = record
    }

    init(from record: CKRecord) {
        self.record = record
    }

    internal func setNotebook(_ notebook: CloudKitNotebook?) {
        if self.notebook == nil, let notebook = notebook {
            self.notebook = ReferenceField(reference: notebook, record: record, key: "notebook", action: .deleteSelf)
        }
        self.notebook?.value = notebook
    }
    internal func appendTextBox(_ textBox: CloudKitTextBox) {
        if textBoxes == nil {
            textBoxes = ReferenceList(record: record, key: "textBoxes")
        }
        textBoxes?.append(textBox, action: .none)
    }
    internal func appendImageBox(_ imageBox: CloudKitImageBox) {
        if imageBoxes == nil {
            imageBoxes = ReferenceList(record: record, key: "imageBoxes")
        }
        imageBoxes?.append(imageBox, action: .none)
    }
}
