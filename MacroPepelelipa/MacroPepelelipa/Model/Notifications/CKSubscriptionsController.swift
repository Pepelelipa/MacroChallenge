//
//  CKSubscriptionsController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 20/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CKSubscriptionController {
    private static let container = CKContainer.init(identifier: "iCloud.Pepelelipa")

    internal static func createWorkspaceSubscription() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Workspace", predicate: predicate, options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate])
        let info = CKSubscription.NotificationInfo()
        info.category = "workspaceDeletion"
        info.alertBody = "Teste"
        info.desiredKeys = ["id"]
        info.shouldBadge = true

        subscription.notificationInfo = info
        container.privateCloudDatabase.save(subscription) { (_, error) in
            print(error)
        }
    }
}
