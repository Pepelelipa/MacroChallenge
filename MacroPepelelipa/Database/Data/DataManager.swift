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
    public func createWorkspace(named name: String) throws -> WorkspaceEntity {
        let cdWorkspace = try coreDataController.createWorkspace(named: name)

        return WorkspaceObject(from: cdWorkspace)
    }

    public func deleteWorkspace(_ workspace: WorkspaceEntity) throws {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.FailedToParse
        }

        try coreDataController.deleteWorkspace(workspaceObject.coreDataObject)
    }

    //MARK: Notebook
    public func createNotebook(in workspace: WorkspaceEntity, named name: String, colorName: String) throws -> NotebookEntity {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.FailedToParse
        }

        let cdNotebook = try coreDataController.createNotebook(in: workspaceObject.coreDataObject, named: name, colorName: colorName)
        return NotebookObject(in: workspaceObject, from: cdNotebook)
    }

    public func deleteNotebook(_ notebook: NotebookEntity) throws {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.FailedToParse
        }

        try coreDataController.deleteNotebook(notebookObject.coreDataObject)
    }

    //MARK: Note
    public func createNote(in notebook: NotebookEntity) throws -> NoteEntity {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.FailedToParse
        }

        let cdNote = try coreDataController.createNote(in: notebookObject.coreDataObject)
        return NoteObject(in: notebookObject, from: cdNote)
    }

    public func deleteNote(_ note: NoteEntity) throws {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        try coreDataController.deleteNote(noteObject.coreDataObject)
    }

    //MARK: TextBox
    public func createTextBox(in note: NoteEntity) throws -> TextBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        let cdTextBox = try coreDataController.createTextBox(in: noteObject.coreDataObject)
        return TextBoxObject(in: noteObject, coreDataObject: cdTextBox)
    }

    public func deleteTextBox(_ textBox: TextBoxEntity) throws {
        guard let textBoxObject = textBox as? TextBoxObject else {
            throw TextBoxError.FailedToParse
        }

        try coreDataController.deleteTextBox(textBoxObject.coreDataObject)
    }

    //MARK: ImageBox
    public func createImageBox(in note: NoteEntity) throws -> ImageBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.FailedToParse
        }

        let cdImageBox = try coreDataController.createImageBox(in: noteObject.coreDataObject)
        return ImageBoxObject(in: noteObject, coreDataObject: cdImageBox)
    }

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
