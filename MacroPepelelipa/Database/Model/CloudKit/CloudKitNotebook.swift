//
//  CloudKitNotebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitNotebook: CloudKitEntity, Equatable {
    static func == (lhs: CloudKitNotebook, rhs: CloudKitNotebook) -> Bool {
        return lhs.record.recordID == rhs.record.recordID
    }

    internal static let recordType: String = "Notebook"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var name: DataProperty<String> = DataProperty(record: record, key: "name")
    internal private(set) lazy var colorName: DataProperty<String> = DataProperty(record: record, key: "colorName")
    internal private(set) var workspace: ReferenceField<CloudKitWorkspace>?
    internal private(set) var notes: ReferenceList<CloudKitNote>?

    init(named name: String, colorName: String, id: UUID) {
        let record = CKRecord(recordType: CloudKitNotebook.recordType)
        record["id"] = id.uuidString
        record["name"] = name
        record["colorName"] = colorName
        self.record = record
    }
    init(from record: CKRecord) {
        self.record = record
    }

    internal func setWorkspace(_ workspace: CloudKitWorkspace?) {
        if self.workspace == nil, let workspace = workspace {
            self.workspace = ReferenceField(reference: workspace, record: record, key: "workspace", action: .deleteSelf)
        }
        self.workspace?.value = workspace
    }
    internal func appendNote(_ note: CloudKitNote) {
        if notes == nil {
            notes = ReferenceList(record: record, key: "notes")
        }
        notes?.append(note, action: .none)
    }
    internal func removeNote(_ note: CloudKitNote) {
        notes?.remove(note)
    }
}
