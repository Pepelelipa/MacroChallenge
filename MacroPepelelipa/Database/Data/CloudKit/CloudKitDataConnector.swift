//
//  CloudKitDataConnector.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 06/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import CloudKit

internal enum DatabaseType {
    case Private
    case Shared
    case Public

    fileprivate static let container = CKContainer.init(identifier: "iCloud.Pepelelipa")

    internal var value: CKDatabase {
        switch self {
        case .Private:
            return DatabaseType.container.privateCloudDatabase
        case .Shared:
            return DatabaseType.container.sharedCloudDatabase
        case .Public:
            return DatabaseType.container.publicCloudDatabase
        }
    }
}

internal class CloudKitDataConnector {
    private init() {
    }

    private static let container: CKContainer = DatabaseType.container

    // MARK: Saving Object
    internal static func saveObject(database: DatabaseType, object: CloudKitEntity,
                                    completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.value.save(object.record) { (_, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                                                "Couldn't save object in iCloud:".localized() + " \(String(describing: error))"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
            return
        }
    }

    // MARK: Saving Objects
    internal static func saveData(database: DatabaseType, entitiesToSave: [CloudKitEntity]) {
        saveData(database: database, entitiesToSave: entitiesToSave, entitiesToDelete: [])
    }
    internal static func deleteData(database: DatabaseType, entitiesToDelete: [CloudKitEntity]) {
        saveData(database: database, entitiesToSave: [], entitiesToDelete: entitiesToDelete)
    }

    internal static func saveData(database: DatabaseType, entitiesToSave: [CloudKitEntity], entitiesToDelete: [CloudKitEntity]) {

        var savingRecords: [CKRecord] = []
        for obj in entitiesToSave {
            savingRecords.append(obj.record)
        }

        var deletingRecords: [CKRecord.ID] = []
        for obj in entitiesToDelete {
            deletingRecords.append(obj.record.recordID)
        }

        let operation: CKModifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: savingRecords, recordIDsToDelete: deletingRecords)
        operation.savePolicy = .changedKeys
        database.value.add(operation)
    }

    // MARK: Deleting Object
    internal static func deleteObject(database: DatabaseType, object: CloudKitEntity, completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.value.delete(withRecordID: object.record.recordID) { (_, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                                                "Couldn't delete object in iCloud:".localized() + " \(String(describing: error))"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
            return
        }
    }

    // MARK: Fetching
    internal static func fetchUserID(completionHandler: @escaping (DataFetchAnswer) -> Void) {
        container.fetchUserRecordID { (userID, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                                                "Couldn't complete fetch:".localized() + " \(String(describing: error))"))
                }
                return
            }
            completionHandler(.successfulWith(result: userID))
        }
    }

    internal static func fetch(recordType: String, database: DatabaseType, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        fetch(query: query, database: database, completionHandler: completionHandler)
    }

    internal static func fetch(references: [CKRecord.Reference], recordType: String, database: DatabaseType, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        let predicate = NSPredicate(format: "%K in %@", "recordID", references)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        fetch(query: query, database: database, completionHandler: completionHandler)
    }

    internal static func fetch(query: CKQuery, database: DatabaseType, completionHandler: @escaping (DataFetchAnswer) -> Void ) {
        database.value.perform(query, inZoneWith: nil) { (results, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                                                "Couldn't complete fetch:".localized() + " \(String(describing: error))"))
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(.successful(results: results ?? []))
            }
        }
    }
}
