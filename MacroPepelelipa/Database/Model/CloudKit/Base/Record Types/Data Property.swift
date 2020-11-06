//
//  Data Property.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 06/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class DataProperty<T: Equatable> {
    private let record: CKRecord
    private let key: String
    public var value: T {
        get {
            guard let val = record.value(forKey: key) as? T else {
                fatalError("Couldn't convert data to associated type.")
            }
            return val
        }
        set {
            record.setValue(newValue, forKey: key)
        }
    }

    init(record: CKRecord, key: String) {
        self.record = record
        self.key = key
    }
}

extension DataProperty {
    static func == (lhs: T, rhs: DataProperty) -> Bool {
        return lhs == rhs.value
    }
    static func != (lhs: T, rhs: DataProperty) -> Bool {
        return lhs != rhs.value
    }
    static func == (lhs: DataProperty, rhs: T) -> Bool {
        return lhs.value == rhs
    }
    static func != (lhs: DataProperty, rhs: T) -> Bool {
        return lhs.value != rhs
    }
}
