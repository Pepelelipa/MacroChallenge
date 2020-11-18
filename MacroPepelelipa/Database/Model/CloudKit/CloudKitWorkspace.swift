//
//  CloudKitWorkspace.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitWorkspace: CloudKitEntity, Equatable {
    static func == (lhs: CloudKitWorkspace, rhs: CloudKitWorkspace) -> Bool {
        return lhs.record.recordID == rhs.record.recordID
    }

    internal static let recordType: String = "Workspace"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var name: DataProperty<String> = DataProperty(record: record, key: "name")
    internal private(set) lazy var isEnabled: DataProperty<Int64> = DataProperty(record: record, key: "isEnabled")
    internal private(set) var notebooks: ReferenceList<CloudKitNotebook>?

    init(named name: String, id: UUID) {
        let record = CKRecord(recordType: CloudKitWorkspace.recordType)
        record["id"] = id.uuidString
        record["isEnabled"] = true
        record["name"] = name
        self.record = record
    }
    init(from record: CKRecord) {
        self.record = record
    }

    internal func appendNotebook(_ notebook: CloudKitNotebook) {
        if notebooks == nil {
            notebooks = ReferenceList(record: record, key: "notebooks")
        }
        notebooks?.append(notebook, action: .none)
    }
    internal func removeNotebook(_ notebook: CloudKitNotebook) {
        notebooks?.remove(notebook)
    }
}
