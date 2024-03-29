//
//  CKSubscriptionsController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 20/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
#if !DEVELOP
import CloudKit

internal class CKSubscriptionController {
    private static let container = CKContainer.init(identifier: "iCloud.Pepelelipa")

    private static var database: CKDatabase {
        return container.privateCloudDatabase
    }

    internal static func createWorkspaceSubscription(errorHandler: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Workspace", predicate: predicate, options: .firesOnRecordDeletion)
        let info = CKSubscription.NotificationInfo()
        info.category = "workspaceNotification"
        info.desiredKeys = ["id"]
        info.soundName = nil
        info.shouldBadge = false
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info
        database.save(subscription) { (_, error) in
            errorHandler(error)
        }
    }

    internal static func createNotebookSubscription(errorHandler: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Notebook", predicate: predicate, options: .firesOnRecordDeletion)
        let info = CKSubscription.NotificationInfo()
        info.category = "notebookNotification"
        info.desiredKeys = ["id"]
        info.soundName = nil
        info.shouldBadge = false
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info
        database.save(subscription) { (_, error) in
            errorHandler(error)
        }
    }

    internal static func createNoteSubscription(errorHandler: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Note", predicate: predicate, options: .firesOnRecordDeletion)
        let info = CKSubscription.NotificationInfo()
        info.category = "noteNotification"
        info.desiredKeys = ["id"]
        info.soundName = nil
        info.shouldBadge = false
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info
        database.save(subscription) { (_, error) in
            errorHandler(error)
        }
    }

    internal static func createTextBoxSubscription(errorHandler: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "TextBox", predicate: predicate, options: .firesOnRecordDeletion)
        let info = CKSubscription.NotificationInfo()
        info.category = "textBoxNotification"
        info.desiredKeys = ["id"]
        info.soundName = nil
        info.shouldBadge = false
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info
        database.save(subscription) { (_, error) in
            errorHandler(error)
        }
    }

    internal static func createImageBoxSubscription(errorHandler: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "ImageBox", predicate: predicate, options: .firesOnRecordDeletion)
        let info = CKSubscription.NotificationInfo()
        info.category = "imageBoxNotification"
        info.desiredKeys = ["id"]
        info.soundName = nil
        info.shouldBadge = false
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info
        database.save(subscription) { (_, error) in
            errorHandler(error)
        }
    }
}
#endif
