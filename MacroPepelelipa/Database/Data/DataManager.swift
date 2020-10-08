//
//  DataManager.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public class DataManager {
    private let coreDataController = CoreDataController()

    //MARK: Workspace
    /**
     Creates a Workspace into the Database
     - Parameter name: The workspace's  name.
     - Throws: Throws if fails to create in CoreData.
     */
    public func createWorkspace(named name: String) throws -> WorkspaceEntity {
        let cdWorkspace = try coreDataController.createWorkspace(named: name)

        return WorkspaceObject(from: cdWorkspace)
    }

    /**
     Deletes a workspace from the Database
     - Parameter workspace: Workspace to be deleted.
     - Throws: Throws if fails to parse object to WorkspaceObject or fails to delete from CoreData.
     */
    public func deleteWorkspace(_ workspace: WorkspaceEntity) throws {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.FailedToParse
        }

        try coreDataController.deleteWorkspace(workspaceObject.coreDataObject)
    }

    //MARK: Notebook
    /**
     Creates a Notebook into the Database
     - Parameter workspace: To what workspace it belongs.
     - Parameter name: The notebook's name.
     - Parameter colorName: The nootebook's color name.
     - Throws: Throws if fails to parse workspace to WorkspaceObject or fails to create in CoreData.
     */
    public func createNotebook(in workspace: WorkspaceEntity, named name: String, colorName: String) throws -> NotebookEntity {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.FailedToParse
        }

        let cdNotebook = try coreDataController.createNotebook(in: workspaceObject.coreDataObject, named: name, colorName: colorName)
        return NotebookObject(in: workspaceObject, from: cdNotebook)
    }

    /**
     Deletes a notebook from Database
     - Parameter notebook: Notebook to be deleted.
     - Throws: Throws if fails to parse object to NotebookObject or fails to delete from CoreData.
     */
    public func deleteNotebook(_ notebook: NotebookEntity) throws {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.FailedToParse
        }

        try coreDataController.deleteNotebook(notebookObject.coreDataObject)
    }

    //MARK: Note
    /**
     Creates a Note into the Database
     - Parameter notebook: To what notebook it belongs.
     - Throws: Throws if fails to parse notebook to NotebookObject or fails to create in CoreData.
     */
    public func createNote(in notebook: NotebookEntity) throws -> NoteEntity {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.FailedToParse
        }

        let cdNote = try coreDataController.createNote(in: notebookObject.coreDataObject)
        return NoteObject(in: notebookObject, from: cdNote)
    }

    /**
     Deletes a note from Database
     - Parameter note: Note to be deleted.
     - Throws: Throws if fails to parse object to NoteObject or fails to delete from CoreData.
     */
    public func deleteNote(_ note: NoteEntity) throws {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        try coreDataController.deleteNote(noteObject.coreDataObject)
    }

    //MARK: TextBox
    /**
     Creates a TextBox into the Database
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse note to NoteObject or fails to create in CoreData.
     */
    public func createTextBox(in note: NoteEntity) throws -> TextBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        let cdTextBox = try coreDataController.createTextBox(in: noteObject.coreDataObject)
        return TextBoxObject(in: noteObject, coreDataObject: cdTextBox)
    }

    /**
     Deletes a TextBox from Database
     - Parameter textBox: TextBox to be deleted.
     - Throws: Throws fails to parse object to TextBoxObject or fails to delete from CoreData.
     */
    public func deleteTextBox(_ textBox: TextBoxEntity) throws {
        guard let textBoxObject = textBox as? TextBoxObject else {
            throw TextBoxError.FailedToParse
        }

        try coreDataController.deleteTextBox(textBoxObject.coreDataObject)
    }

    //MARK: ImageBox
    /**
     Creates a ImageBox into the Database
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse note to NoteObject or fails to create in CoreData.
     */
    public func createImageBox(in note: NoteEntity) throws -> ImageBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        let cdImageBox = try coreDataController.createImageBox(in: noteObject.coreDataObject)
        return ImageBoxObject(in: noteObject, coreDataObject: cdImageBox)
    }

    /**
     Deletes a ImageBox from Database
     - Parameter imageBox: ImageBox to be deleted.
     - Throws: Throws fails to parse object to ImageBoxObject or fails to delete from CoreData.
     */
    public func deleteImageBox(_ imageBox: ImageBoxEntity) throws {
        guard let imageBoxObject = imageBox as? ImageBoxObject else {
            throw ImageBoxError.FailedToParse
        }

        try coreDataController.deleteImageBox(imageBoxObject.coreDataObject)
    }

    //MARK: Singleton Basic Properties
    private init() {
    }
    public class func shared() -> DataManager {
        return sharedDataManager
    }
    private static var sharedDataManager: DataManager = {
        let dManager = DataManager()
        return dManager
    }()
}
