//
//  CoreDataController.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreData

internal class CoreDataController {

    ///Persistent container of our CoreData
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSCustomPersistentContainer(name: "DataModel")

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    ///Context of our CoreData
    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: Fetches
    
    internal func fetchWorkspaces() throws -> [Workspace] {
        return try context.fetch(Workspace.fetchRequest())
    }

    internal func fetchTextBox(id: String) throws -> TextBox? {
        let textBoxFetchRequest: NSFetchRequest<TextBox> = TextBox.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        textBoxFetchRequest.predicate = predicate

        return try context.fetch(textBoxFetchRequest).first
    }

    internal func fetchImageBox(id: String) throws -> ImageBox? {
        let imageBoxFetchRequest: NSFetchRequest<ImageBox> = ImageBox.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        imageBoxFetchRequest.predicate = predicate

        return try context.fetch(imageBoxFetchRequest).first
    }

    // MARK: Workspace
    /**
     Creates a Workspace into the CoreData
     - Parameter name: The workspace's  name.
     - Parameter id: The workspace's UUID.
     - Throws: Throws if fails to parse object to Workspace or the context saving is unsuccessful.
     */
    internal func createWorkspace(named name: String, id: UUID) throws -> Workspace {
        guard let workspace = NSEntityDescription.insertNewObject(forEntityName: "Workspace", into: context) as? Workspace else {
            throw CoreDataError.failedToParseObject
        }
        workspace.id = id
        workspace.name = name

        return workspace
    }

    /**
     Deletes a workspace from CoreData
     - Parameter workspace: Workspace to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteWorkspace(_ workspace: Workspace) throws {
        context.delete(workspace)
    }

    // MARK: Notebook
    /**
     Creates a Notebook into the CoreData
     - Parameter workspace: To what workspace it belongs.
     - Parameter name: The notebook's name.
     - Parameter colorName: The nootebook's color name.
     - Throws: Throws if fails to parse object to Notebook or the context saving is unsuccessful.
     */
    internal func createNotebook(in workspace: Workspace, id: UUID, named name: String, colorName: String) throws -> Notebook {
        guard let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context) as? Notebook else {
            throw CoreDataError.failedToParseObject
        }
        notebook.id = id
        notebook.workspace = workspace
        notebook.name = name
        notebook.colorName = colorName

        return notebook
    }
    /**
     Deletes a notebook from CoreData
     - Parameter notebook: Notebook to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteNotebook(_ notebook: Notebook) throws {
        context.delete(notebook)
    }

    // MARK: Note
    /**
     Creates a Note into the CoreData
     - Parameter notebook: To what notebook it belongs.
     - Throws: Throws if fails to parse object to Note or the context saving is unsuccessful.
     */
    internal func createNote(in notebook: Notebook?, id: UUID) throws -> Note {
        guard let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as? Note else {
            throw CoreDataError.failedToParseObject
        }

        note.id = id
        note.notebook = notebook

        return note
    }

    /**
     Deletes a note from CoreData
     - Parameter note: Note to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteNote(_ note: Note) throws {
        context.delete(note)
    }

    // MARK: TextBox
    /**
     Creates a TextBox into the CoreData
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse object to TextBox or the context saving is unsuccessful.
     */
    internal func createTextBox(in note: Note, id: UUID) throws -> TextBox {
        guard let textBox = NSEntityDescription.insertNewObject(forEntityName: "TextBox", into: context) as? TextBox else {
            throw CoreDataError.failedToParseObject
        }

        textBox.id = id
        textBox.note = note

        return textBox
    }

    /**
     Deletes a TextBox from CoreData
     - Parameter textBox: TextBox to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteTextBox(_ textBox: TextBox) throws {
        context.delete(textBox)
    }

    // MARK: ImageBox
    /**
     Creates a ImageBox into the CoreData
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse object to ImageBox or the context saving is unsuccessful.
     */
    internal func createImageBox(in note: Note, id: UUID, at imagePath: String) throws -> ImageBox {
        guard let imageBox = NSEntityDescription.insertNewObject(forEntityName: "ImageBox", into: context) as? ImageBox else {
            throw CoreDataError.failedToParseObject
        }

        imageBox.id = id
        imageBox.imagePath = imagePath
        imageBox.note = note

        return imageBox
    }

    /**
     Deletes a ImageBox from CoreData
     - Parameter imageBox: ImageBox to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteImageBox(_ imageBox: ImageBox) throws {
        context.delete(imageBox)
    }
}
