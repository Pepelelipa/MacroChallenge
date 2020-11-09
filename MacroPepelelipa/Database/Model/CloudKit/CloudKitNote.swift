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

    internal lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal lazy var title: DataProperty<Data> = DataProperty(record: record, key: "title")
    internal lazy var text: DataProperty<Data> = DataProperty(record: record, key: "text")
    //TODO: Notebooks, TextBoxes and IamgeBoxes

    init(from note: NoteObject) {
        let record = CKRecord(recordType: CloudKitNote.recordType)
        record["id"] = try? note.getID().uuidString
        record["title"] = note.title.toData()
        record["text"] = note.text.toData()
        //TODO: Notebooks, TextBoxes and IamgeBoxes
        self.record = record
    }

    init(record: CKRecord) {
        self.record = record
    }
}
