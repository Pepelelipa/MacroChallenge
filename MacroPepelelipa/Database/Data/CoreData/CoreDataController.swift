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

    internal func deleteWorkspace(_ workspace: Workspace) throws {
        context.delete(workspace)
        try saveContext()
    }

    //MARK: Notebook
    internal func createNotebook(in workspace: Workspace, named name: String, colorName: String) throws -> Notebook {
        guard let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context) as? Notebook else {
            throw CoreDataError.FailedToParseObject
        }
        notebook.workspace = workspace
        notebook.name = name
        notebook.colorName = colorName

        try saveContext()

        return notebook
    }

    internal func deleteNotebook(_ notebook: Notebook) throws {
        context.delete(notebook)
        try saveContext()
    }

    //MARK: Note
    internal func createNote(in notebook: Notebook) throws -> Note {
        guard let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as? Note else {
            throw CoreDataError.FailedToParseObject
        }
        note.notebook = notebook

        try saveContext()

        return note
    }

    internal func deleteNote(_ note: Note) throws {
        context.delete(note)
        try saveContext()
    }

    //MARK: TextBox
    internal func createTextBox(in note: Note) throws -> TextBox {
        guard let textBox = NSEntityDescription.insertNewObject(forEntityName: "TextBox", into: context) as? TextBox else {
            throw CoreDataError.FailedToParseObject
        }

        textBox.note = note

        try saveContext()

        return textBox
    }

    internal func deleteTextBox(_ textBox: TextBox) throws {
        context.delete(textBox)
        try saveContext()
    }

    //MARK: TextBox
    internal func createImageBox(in note: Note) throws -> ImageBox {
        guard let imageBox = NSEntityDescription.insertNewObject(forEntityName: "ImageBox", into: context) as? ImageBox else {
            throw CoreDataError.FailedToParseObject
        }

        imageBox.note = note

        try saveContext()

        return imageBox
    }

    internal func deleteImageBox(_ imageBox: ImageBox) throws {
        context.delete(imageBox)
        try saveContext()
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
