//
//  CloudKitRemoteConfig.swift
//  Database
//
//  Created by Pedro Farina on 26/06/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitRemoteConfig: CloudKitEntity {
    static let recordType: String = "RemoteConfig"
    internal var record: CKRecord
    
    internal private(set) lazy var identifier: DataProperty<String> = DataProperty(record: record, key: "identifier")
    internal private(set) lazy var isActive: DataProperty<Int64> = DataProperty(record: record, key: "isActive")
    internal private(set) lazy var maxExecutions: DataProperty<Int64> = DataProperty(record: record, key: "maxExecutions")
    internal private(set) lazy var version: DataProperty<Int64> = DataProperty(record: record, key: "version")
    
    init(from record: CKRecord) {
        self.record = record
    }
}
