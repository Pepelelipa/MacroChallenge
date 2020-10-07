//
//  CoreDataController.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreData

internal class CoreDataController {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSCustomPersistentContainer(name: "DataModel")

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private lazy var context:NSManagedObjectContext = persistentContainer.viewContext

    private var workspaces: [Workspace] = []

    internal func fetchWorkspaces() throws {
        workspaces = try context.fetch(Workspace.fetchRequest())
    }
}
