//
//  CloudKitImageBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal class CloudKitImageBox: CloudKitEntity, Equatable {
    static func == (lhs: CloudKitImageBox, rhs: CloudKitImageBox) -> Bool {
        return lhs.record.recordID == rhs.record.recordID
    }

    internal static let recordType: String = "ImageBox"
    internal var record: CKRecord

    internal private(set) lazy var id: DataProperty<String> = DataProperty(record: record, key: "id")
    internal private(set) lazy var image: DataProperty<CKAsset> = DataProperty(record: record, key: "image")
    internal private(set) lazy var width: DataProperty<Double> = DataProperty(record: record, key: "width")
    internal private(set) lazy var height: DataProperty<Double> = DataProperty(record: record, key: "height")
    internal private(set) lazy var x: DataProperty<Double> = DataProperty(record: record, key: "x")
    internal private(set) lazy var y: DataProperty<Double> = DataProperty(record: record, key: "y")
    internal private(set) lazy var z: DataProperty<Double> = DataProperty(record: record, key: "z")
    internal private(set) var note: ReferenceField<CloudKitNote>?

    init(id: UUID, at imagePath: String) {
        let record = CKRecord(recordType: CloudKitImageBox.recordType)
        record["id"] = id.uuidString
        if let filePath = FileHelper.getFilePath(fileName: imagePath) {
            record["image"] = CKAsset(fileURL: URL(fileURLWithPath: filePath))
        }
        self.record = record
    }

    init(from record: CKRecord) {
        self.record = record
    }

    internal func setNote(_ note: CloudKitNote?) {
        if self.note == nil, let note = note {
            self.note = ReferenceField(reference: note, record: record, key: "note", action: .deleteSelf)
        }
        self.note?.value = note
    }
}
