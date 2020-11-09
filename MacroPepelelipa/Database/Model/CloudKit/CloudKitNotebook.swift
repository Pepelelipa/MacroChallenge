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

    internal lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal lazy var name: DataProperty<String> = DataProperty(record: record, key: "name")
    internal lazy var colorName: DataProperty<String> = DataProperty(record: record, key: "colorName")
    //TODO: Notes and workspace

    init(from notebook: NotebookObject) {
        let record = CKRecord(recordType: CloudKitNotebook.recordType)
        record["id"] = try? notebook.getID().uuidString
        record["name"] = notebook.name
        record["colorName"] = notebook.colorName
        //TODO: Notes and workspace
        self.record = record
    }
    init(record: CKRecord) {
        self.record = record
    }
}
