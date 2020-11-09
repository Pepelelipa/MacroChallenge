//
//  CloudKitTextBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal class CloudKitTextBox: CloudKitEntity {
    internal static let recordType: String = "TextBox"
    internal var record: CKRecord

    internal lazy var text: DataProperty<Data> = DataProperty(record: record, key: "text")
    internal lazy var width: DataProperty<Double> = DataProperty(record: record, key: "width")
    internal lazy var height: DataProperty<Double> = DataProperty(record: record, key: "height")
    internal lazy var x: DataProperty<Double> = DataProperty(record: record, key: "x")
    internal lazy var y: DataProperty<Double> = DataProperty(record: record, key: "y")
    internal lazy var z: DataProperty<Double> = DataProperty(record: record, key: "z")
    //TODO: Note

    init(from textBox: TextBoxObject) {
        let record = CKRecord(recordType: CloudKitTextBox.recordType)
        record["text"] = textBox.text.toData()
        record["width"] = Double(textBox.width)
        record["height"] = Double(textBox.height)
        record["x"] = Double(textBox.x)
        record["y"] = Double(textBox.y)
        record["z"] = Double(textBox.z)
        //TODO: Note
        self.record = record
    }

    init(record: CKRecord) {
        self.record = record
    }
}

