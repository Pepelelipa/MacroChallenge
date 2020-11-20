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

    ///Fetches all workspaces
    internal func fetchWorkspaces() throws -> [Workspace] {
        return try context.fetch(Workspace.fetchRequest())
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
        try saveContext()

        return workspace
    }

    /**
     Creates a Workspace into the CoreData
     - Parameter ckWorkspace: The CloudKit's Workspace.
     - Throws: Throws if fails to parse object to Workspace or the context saving is unsuccessful.
     */
    internal func createWorkspace(from ckWorkspace: CloudKitWorkspace) throws -> Workspace {
        if let id = UUID(uuidString: ckWorkspace.id.value ?? "") {
            guard let workspace = NSEntityDescription.insertNewObject(forEntityName: "Workspace", into: context) as? Workspace else {
                throw CoreDataError.failedToParseObject
            }

            workspace.id = id
            workspace <- ckWorkspace

            if let notebooks = ckWorkspace.notebooks?.references {
                for notebook in notebooks {
                    _ = try self.createNotebook(from: notebook, in: workspace)
                }
            }

            try saveContext()

            return workspace
        } else {
            throw PersistentError.idWasNull
        }
    }

    /**
     Deletes a workspace from CoreData
     - Parameter workspace: Workspace to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteWorkspace(_ workspace: Workspace) throws {
        context.delete(workspace)
        try saveContext()
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

        try saveContext()

        return notebook
    }

    /**
     Creates a Notebook into the CoreData
     - Parameter ckNotebook: The CloudKit's Notebook
     - Parameter workspace: To what workspace it belongs
     - Throws: Throws if fails to parse object to Notebook or the context saving is unsuccessful.
     */
    internal func createNotebook(from ckNotebook: CloudKitNotebook, in workspace: Workspace) throws -> Notebook {
        if let id = UUID(uuidString: ckNotebook.id.value ?? "") {
            guard let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context) as? Notebook else {
                throw CoreDataError.failedToParseObject
            }

            notebook.id = id
            notebook <- ckNotebook
            notebook.workspace = workspace

            if let notes = ckNotebook.notes?.references {
                for note in notes {
                    _ = try createNote(from: note, in: notebook)
                }
            }

            try saveContext()

            return notebook
        } else {
            throw PersistentError.idWasNull
        }
    }

    /**
     Deletes a notebook from CoreData
     - Parameter notebook: Notebook to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteNotebook(_ notebook: Notebook) throws {
        context.delete(notebook)
        try saveContext()
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

        try saveContext()

        return note
    }

    /**
     Creates a Note into the CoreData
     - Parameter ckNote: The CloudKit's Note.
     - Parameter notebook: To what notebook it belongs.
     - Throws: Throws if fails to parse object to Note or the context saving is unsuccessful.
     */
    internal func createNote(from ckNote: CloudKitNote, in notebook: Notebook) throws -> Note {
        if let id = UUID(uuidString: ckNote.id.value ?? "") {
            guard let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as? Note else {
                throw CoreDataError.failedToParseObject
            }

            note.id = id
            note <- ckNote
            note.notebook = notebook

            if let textBoxes = ckNote.textBoxes?.references {
                for textBox in textBoxes {
                    _ = try createTextBox(from: textBox, in: note)
                }
            }

            if let imageBoxes = ckNote.imageBoxes?.references {
                for imageBox in imageBoxes {
                    _ = try createImageBox(from: imageBox, in: note)
                }
            }

            try saveContext()

            return note
        } else {
            throw PersistentError.idWasNull
        }
    }

    /**
     Deletes a note from CoreData
     - Parameter note: Note to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteNote(_ note: Note) throws {
        context.delete(note)
        try saveContext()
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

        try saveContext()

        return textBox
    }

    /**
     Creates a TextBox into the CoreData
     - Parameter ckTextBox: The CloudKit's TextBox.
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse object to TextBox or the context saving is unsuccessful.
     */
    internal func createTextBox(from ckTextBox: CloudKitTextBox, in note: Note) throws -> TextBox {
        if let id = UUID(uuidString: ckTextBox.id.value ?? "") {
            guard let textBox = NSEntityDescription.insertNewObject(forEntityName: "TextBox", into: context) as? TextBox else {
                throw CoreDataError.failedToParseObject
            }

            textBox.id = id
            textBox <- ckTextBox
            textBox.note = note

            try saveContext()

            return textBox
        } else {
            throw PersistentError.idWasNull
        }
    }

    /**
     Deletes a TextBox from CoreData
     - Parameter textBox: TextBox to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteTextBox(_ textBox: TextBox) throws {
        context.delete(textBox)
        try saveContext()
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

        try saveContext()

        return imageBox
    }

    /**
     Creates a ImageBox into the CoreData
     - Parameter ckImageBox: The CloudKit's ImageBox.
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse object to ImageBox or the context saving is unsuccessful.
     */
    internal func createImageBox(from ckImageBox: CloudKitImageBox, in note: Note) throws -> ImageBox {
        if let id = UUID(uuidString: ckImageBox.id.value ?? "") {
            guard let imageBox = NSEntityDescription.insertNewObject(forEntityName: "ImageBox", into: context) as? ImageBox else {
                throw CoreDataError.failedToParseObject
            }
            
            imageBox.id = id
            imageBox <- ckImageBox
            imageBox.note = note

            try saveContext()

            return imageBox
        } else {
            throw PersistentError.idWasNull
        }
    }

    /**
     Deletes a ImageBox from CoreData
     - Parameter imageBox: ImageBox to be deleted.
     - Throws: Throws if saving deletion is unsuccessful.
     */
    internal func deleteImageBox(_ imageBox: ImageBox) throws {
        context.delete(imageBox)
        try saveContext()
    }

    // MARK: Context
    internal func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.failedToSaveContext
            }
        }
    }
}
