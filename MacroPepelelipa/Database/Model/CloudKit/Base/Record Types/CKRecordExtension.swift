//
//  CKRecordExtension.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 06/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal extension CKRecord {
    static func from(_ workspace: WorkspaceObject) -> CKRecord {
        let record = CKRecord(recordType: type(of: workspace).recordType)
        record["id"] = try? workspace.getID().uuidString
        record["isEnabled"] = workspace.isEnabled
        record["name"] = workspace.name
        return record
    }
    static func from(_ notebook: NotebookObject) -> CKRecord {
        let record = CKRecord(recordType: type(of: notebook).recordType)
        record["id"] = try? notebook.getID().uuidString
        record["name"] = notebook.name
        record["colorName"] = notebook.colorName
        
        return record
    }
    static func from(_ note: NoteObject) -> CKRecord {
        let record = CKRecord(recordType: type(of: note).recordType)
        record["id"] = try? note.getID().uuidString
        record["title"] = note.title.toData()
        record["text"] = note.text.toData()
        return record
    }
    static func from(_ textBox: TextBoxObject) -> CKRecord {
        let record = CKRecord(recordType: type(of: textBox).recordType)
        record["text"] = textBox.text.toData()
        record["width"] = Double(textBox.width)
        record["height"] = Double(textBox.height)
        record["x"] = Double(textBox.x)
        record["y"] = Double(textBox.y)
        record["z"] = Double(textBox.z)
        return record
    }
    static func from(_ imageBox: ImageBoxObject) -> CKRecord {
        let record = CKRecord(recordType: type(of: imageBox).recordType)
//        record["image"] = 
        record["width"] = Double(imageBox.width)
        record["height"] = Double(imageBox.height)
        record["x"] = Double(imageBox.x)
        record["y"] = Double(imageBox.y)
        record["z"] = Double(imageBox.z)
        return record
    }
}
