//
//  ReferenceList.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class ReferenceList<T: CloudKitEntity> {
    private let record: CKRecord
    private let key: String
    internal private(set) var recordReferences: [CKRecord.Reference] = []
    internal private(set) var references: [T] = []

    internal init(record: CKRecord, key: String) {
        self.record = record
        self.key = key
    }

    internal func first(where predicate: (CloudKitEntity) throws -> Bool) rethrows -> CloudKitEntity? {
        return try references.first(where: predicate)
    }

    internal func append(_ value: T, action: CKRecord_Reference_Action) {
        references.append(value)
        let ref = CKRecord.Reference(recordID: value.record.recordID, action: action)
        recordReferences.append(ref)
        record[key] = recordReferences
    }

    internal func remove(at index: Int) {
        references.remove(at: index)
        recordReferences.remove(at: index)
        record.setValue(recordReferences, forKey: key)
    }

    internal func removeAll() {
        references = []
        recordReferences = []
        record.setValue(recordReferences, forKey: key)
    }
}

internal extension ReferenceList where T: Equatable {

    func remove(_ value: T) {
        if let index = firstIndex(of: value) {
            remove(at: index)
        }
    }

    func firstIndex(of value: T) -> Int? {
        return references.firstIndex(of: value)
    }

    func contains(_ value: T) -> Bool {
        return references.contains(value)
    }

    static func == (lhs: [T], rhs: ReferenceList) -> Bool {
        let count = lhs.count
        if count != rhs.references.count {
            return false
        }
        var ret: Bool = true
        for index in 0..<count {
            ret = ret && lhs[index] == rhs.references[index]
        }

        return ret
    }
    static func != (lhs: [T], rhs: ReferenceList) -> Bool {
        let count = lhs.count
        if count != rhs.references.count {
            return true
        }
        var ret: Bool = false
        for index in 0..<count {
            ret = ret || lhs[index] == rhs.references[index]
        }

        return ret
    }

    static func == (lhs: ReferenceList, rhs: [T]) -> Bool {
        let count = rhs.count
        if count != lhs.references.count {
            return false
        }
        var ret: Bool = true
        for index in 0..<count {
            ret = ret && rhs[index] == lhs.references[index]
        }

        return ret
    }
    static func != (lhs: ReferenceList, rhs: [T]) -> Bool {
        let count = rhs.count
        if count != lhs.references.count {
            return true
        }
        var ret: Bool = false
        for index in 0..<count {
            ret = ret || rhs[index] == lhs.references[index]
        }

        return ret
    }
}
