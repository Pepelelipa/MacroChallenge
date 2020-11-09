//
//  ReferenceField.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class ReferenceField<T: CloudKitEntity> {
    private let record: CKRecord
    private let key: String
    private let action: CKRecord_Reference_Action

    internal private(set) var referenceValue: CKRecord.Reference?
    internal var value: T? {
        willSet {
            if let newValue = newValue {
                referenceValue = CKRecord.Reference(recordID: newValue.record.recordID, action: action)
                record.setValue(referenceValue, forKey: key)
            } else {
                referenceValue = nil
                record.setNilValueForKey(key)
            }
        }
    }

    internal init(record: CKRecord, key: String, action: CKRecord_Reference_Action) {
        self.record = record
        self.key = key
        self.action = action
    }
}

extension ReferenceField where T: Equatable {
    static func == (lhs: T, rhs: ReferenceField) -> Bool {
        return lhs == rhs.value
    }
    static func != (lhs: T, rhs: ReferenceField) -> Bool {
        return lhs != rhs.value
    }

    static func == (lhs: ReferenceField, rhs: T) -> Bool {
        return lhs.value == rhs
    }
    static func != (lhs: ReferenceField, rhs: T) -> Bool {
        return lhs.value != rhs
    }
}
