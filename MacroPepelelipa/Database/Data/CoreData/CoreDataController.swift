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

    internal func fetchWorkspaces() throws -> [Workspace] {
        return try context.fetch(Workspace.fetchRequest())
    }

    //MARK: Workspace
    internal func createWorkspace(named name: String) throws -> Workspace {
        guard let workspace = NSEntityDescription.insertNewObject(forEntityName: "Workspace", into: context) as? Workspace else {
            throw CoreDataError.FailedToParseObject
        }
        workspace.name = name
        try saveContext()

        return workspace
    }

    //MARK: Context
    private func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.FailedToSaveContext
            }
        }
    }
}
