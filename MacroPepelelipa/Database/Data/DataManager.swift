//
//  DataManager.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public enum ObservableCreationType {
    case workspace
    case notebook
    case note
}

public class DataManager {
    private let coreDataController = CoreDataController()
    private let cloudKitController = CloudKitDataController()

    ///Save all modified objects
    /// - Throws: Throws if Core Data fails to save.
    internal func saveObjects(_ entities: [PersistentEntity]) throws {
        try coreDataController.saveContext()

        var cloudKitEntities: [CloudKitEntity] = []
        for persistentEntity in entities {
            if let wrapper = persistentEntity as? CloudKitObjectWrapper,
               let cloudKitEntity = wrapper.cloudKitObject {
                cloudKitEntities.append(cloudKitEntity)
            }
        }
        CloudKitDataConnector.saveData(database: .Private, entitiesToSave: cloudKitEntities)
    }

    private var observers: [(EntityObserver, ObservableCreationType)] = []
    public func addCreationObserver(_ observer: EntityObserver, type: ObservableCreationType) {
        observers.append((observer, type))
    }
    public func removeObserver(_ observer: EntityObserver) {
        if let index = observers.firstIndex(where: { $0.0 === observer }) {
            observers.remove(at: index)
        }
    }

    private func notifyCreation(_ entity: ObservableEntity, type: ObservableCreationType) {
        for observer in observers where observer.1 == type {
            observer.0.entityWasCreated(entity)
        }
    }
    private func notifyDeletion(_ entity: ObservableEntity, type: ObservableCreationType) {
        for observer in observers where observer.1 == type {
            observer.0.entityShouldDelete(entity)
        }
    }

    // MARK: Workspace

    public func fetchWorkspaces() throws -> [WorkspaceEntity] {
        let cdWorkspaces = try coreDataController.fetchWorkspaces()
        return cdWorkspaces.map({ WorkspaceObject(from: $0) })
    }

    /**
     Creates a Workspace into the Database
     - Parameter name: The workspace's  name.
     - Throws: Throws if fails to create in CoreData.
     */
    public func createWorkspace(named name: String) throws -> WorkspaceEntity {
        let id = UUID()
        let cdWorkspace = try coreDataController.createWorkspace(named: name, id: id)
        let ckWorkspace = cloudKitController.createWorkspace(named: name, id: id)

        let workspaceObject = WorkspaceObject(from: cdWorkspace, and: ckWorkspace)
        defer {
            notifyCreation(workspaceObject, type: .workspace)
        }

        return workspaceObject
    }

    /**
     Deletes a workspace from the Database
     - Parameter workspace: Workspace to be deleted.
     - Throws: Throws if fails to parse object to WorkspaceObject or fails to delete from CoreData.
     */
    public func deleteWorkspace(_ workspace: WorkspaceEntity) throws {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.failedToParse
        }

        try coreDataController.deleteWorkspace(workspaceObject.coreDataWorkspace)
        try workspaceObject.removeReferences()
        if let ckWorkspace = workspaceObject.cloudKitWorkspace {
            cloudKitController.deleteWorkspace(ckWorkspace)
        }
        notifyDeletion(workspace, type: .workspace)
    }

    // MARK: Notebook
    /**
     Creates a Notebook into the Database
     - Parameter workspace: To what workspace it belongs.
     - Parameter name: The notebook's name.
     - Parameter colorName: The nootebook's color name.
     - Throws: Throws if fails to parse workspace to WorkspaceObject or fails to create in CoreData.
     */
    public func createNotebook(in workspace: WorkspaceEntity, named name: String, colorName: String) throws -> NotebookEntity {
        guard let workspaceObject = workspace as? WorkspaceObject else {
            throw WorkspaceError.failedToParse
        }
        guard let ckWorkspace = workspaceObject.cloudKitWorkspace else {
            throw WorkspaceError.workspaceWasNull
        }

        let id = UUID()
        let cdNotebook = try coreDataController.createNotebook(in: workspaceObject.coreDataWorkspace, id: id, named: name, colorName: colorName)
        let ckNotebook = cloudKitController.createNotebook(in: ckWorkspace, id: id, named: name, colorName: colorName)

        let notebookObject = NotebookObject(in: workspaceObject, from: cdNotebook, and: ckNotebook)
        defer {
            notifyCreation(notebookObject, type: .notebook)
        }

        return notebookObject
    }

    /**
     Deletes a notebook from Database
     - Parameter notebook: Notebook to be deleted.
     - Throws: Throws if fails to parse object to NotebookObject or fails to delete from CoreData.
     */
    public func deleteNotebook(_ notebook: NotebookEntity) throws {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.failedToParse
        }

        try coreDataController.deleteNotebook(notebookObject.coreDataNotebook)
        try notebookObject.removeReferences()
        if let ckNotebook = notebookObject.cloudKitNotebook {
            cloudKitController.deleteNotebook(ckNotebook)
        }
        notifyDeletion(notebook, type: .notebook)
    }

    // MARK: Note
    /**
     Creates a Note into the Database
     - Parameter notebook: To what notebook it belongs.
     - Throws: Throws if fails to parse notebook to NotebookObject or fails to create in CoreData.
     */
    public func createNote(in notebook: NotebookEntity) throws -> NoteEntity {
        guard let notebookObject = notebook as? NotebookObject else {
            throw NotebookError.failedToParse
        }
        guard let ckNotebook = notebookObject.cloudKitNotebook else {
            throw NotebookError.notebookWasNull
        }

        let id = UUID()
        let cdNote = try coreDataController.createNote(in: notebookObject.coreDataNotebook, id: id)
        let ckNote = cloudKitController.createNote(in: ckNotebook, id: id)

        let noteObject = NoteObject(in: notebookObject, from: cdNote, and: ckNote)
        defer {
            notifyCreation(noteObject, type: .note)
        }

        return noteObject
    }

    /**
     Deletes a note from Database
     - Parameter note: Note to be deleted.
     - Throws: Throws if fails to parse object to NoteObject or fails to delete from CoreData.
     */
    public func deleteNote(_ note: NoteEntity) throws {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.failedToParse
        }

        try coreDataController.deleteNote(noteObject.coreDataNote)
        try noteObject.removeReferences()
        if let ckNote = noteObject.cloudKitNote {
            cloudKitController.deleteNote(ckNote)
        }
        notifyDeletion(note, type: .note)
    }

    // MARK: TextBox
    /**
     Creates a TextBox into the Database
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse note to NoteObject or fails to create in CoreData.
     */
    public func createTextBox(in note: NoteEntity) throws -> TextBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.failedToParse
        }
        guard let ckNote = noteObject.cloudKitNote else {
            throw NoteError.noteWasNull
        }

        let id = UUID()
        let cdTextBox = try coreDataController.createTextBox(in: noteObject.coreDataNote, id: id)
        let ckTextBox = cloudKitController.createTextBox(in: ckNote, id: id)
        return TextBoxObject(in: noteObject, from: cdTextBox, and: ckTextBox)
    }

    /**
     Deletes a TextBox from Database
     - Parameter textBox: TextBox to be deleted.
     - Throws: Throws fails to parse object to TextBoxObject or fails to delete from CoreData.
     */
    public func deleteTextBox(_ textBox: TextBoxEntity) throws {
        guard let textBoxObject = textBox as? TextBoxObject else {
            throw TextBoxError.failedToParse
        }

        try coreDataController.deleteTextBox(textBoxObject.coreDataTextBox)
        try textBoxObject.removeReferences()
        if let ckTextBox = textBoxObject.cloudKitTextBox {
            cloudKitController.deleteTextBox(ckTextBox)
        }
    }

    // MARK: ImageBox
    /**
     Creates a ImageBox into the Database
     - Parameter note: To what note it belongs.
     - Throws: Throws if fails to parse note to NoteObject or fails to create in CoreData.
     */
    public func createImageBox(in note: NoteEntity, at imagePath: String) throws -> ImageBoxEntity {
        guard let noteObject = note as? NoteObject else {
            throw NoteError.failedToParse
        }
        guard let ckNote = noteObject.cloudKitNote else {
            throw NoteError.noteWasNull
        }

        let id = UUID()
        let cdImageBox = try coreDataController.createImageBox(in: noteObject.coreDataNote, id: id, at: imagePath)
        let ckImageBox = cloudKitController.createImageBox(in: ckNote, id: id, at: imagePath)
        return ImageBoxObject(in: noteObject, for: cdImageBox, and: ckImageBox)
    }

    /**
     Deletes a ImageBox from Database
     - Parameter imageBox: ImageBox to be deleted.
     - Throws: Throws fails to parse object to ImageBoxObject or fails to delete from CoreData.
     */
    public func deleteImageBox(_ imageBox: ImageBoxEntity) throws {
        guard let imageBoxObject = imageBox as? ImageBoxObject else {
            throw ImageBoxError.failedToParse
        }

        _ = try? FileHelper.deleteImage(fileName: imageBox.imagePath)

        try coreDataController.deleteImageBox(imageBoxObject.coreDataImageBox)
        try imageBoxObject.removeReferences()
        if let ckImageBox = imageBoxObject.cloudKitImageBox {
            cloudKitController.deleteImageBox(ckImageBox)
        }
    }

    // MARK: Singleton Basic Properties
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
