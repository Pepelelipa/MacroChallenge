//
//  CloudKitNotebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitNotebook: CloudKitEntity {
    internal static let recordType: String = "Notebook"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var name: DataProperty<String> = DataProperty(record: record, key: "name")
    internal private(set) lazy var colorName: DataProperty<String> = DataProperty(record: record, key: "colorName")
    internal private(set) var notes: ReferenceList<CloudKitNote>?
    //TODO: Workspace

    init(from notebook: NotebookObject) {
        let record = CKRecord(recordType: CloudKitNotebook.recordType)
        record["id"] = try? notebook.getID().uuidString
        record["name"] = notebook.name
        record["colorName"] = notebook.colorName
        self.record = record
    }
    init(from record: CKRecord) {
        self.record = record
    }

    internal func appendNote(_ note: CloudKitNote) {
        if notes == nil {
            notes = ReferenceList(record: record, key: "notes")
        }
        notes?.append(note, action: .none)
    }
}
