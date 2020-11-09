//
//  CloudKitWorkspace.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitWorkspace: CloudKitEntity {
    internal static let recordType: String = "Workspace"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var name: DataProperty<String> = DataProperty(record: record, key: "name")
    internal private(set) lazy var isEnabled: DataProperty<Int64> = DataProperty(record: record, key: "isEnabled")
    //TODO: Notebooks

    init(from workspace: WorkspaceObject) {
        let record = CKRecord(recordType: CloudKitWorkspace.recordType)
        record["id"] = try? workspace.getID().uuidString
        record["isEnabled"] = workspace.isEnabled
        record["name"] = workspace.name
        //TODO: Notebooks
        self.record = record
    }
    init(from record: CKRecord) {
        self.record = record
    }
}
