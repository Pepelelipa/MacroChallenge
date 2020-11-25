//
//  CloudKitDataController.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable cyclomatic_complexity

import CloudKit

internal class CloudKitDataController {
    private let database: DatabaseType = .Private
    private var savingQueue: [CloudKitEntity] = []

    // MARK: Workspace
    /**
     Creates a Workspace into CloudKit.
     - Parameter name: The workspace's  name.
     - Parameter id: The workspace's UUID.
     */
    internal func createWorkspace(named name: String, id: UUID) -> CloudKitWorkspace {
        let workspace = CloudKitWorkspace(named: name, id: id)
        saveData(entitiesToSave: [workspace])
        return workspace
    }

    /**
     Creates a Workspace into CloudKit.
     - Parameter workspace: The CoreData workspace.
     */
    internal func createWorkspace(from workspace: Workspace) -> CloudKitWorkspace {
        let record = CKRecord(recordType: CloudKitWorkspace.recordType)
        let ckworkspace = CloudKitWorkspace(from: record)
        savingQueue.append(ckworkspace)
        ckworkspace <- workspace
        if let notebooks = workspace.notebooks?.array as? [Notebook] {
            for notebook in notebooks {
                _ = createNotebook(from: notebook, in: ckworkspace, shouldSave: false)
            }
        }

        saveData(entitiesToSave: savingQueue)
        return ckworkspace
    }

    /**
     Deletes a workspace from CloudKit
     - Parameter workspace: Workspace to be deleted.
     */
    internal func deleteWorkspace(_ workspace: CloudKitWorkspace) {
        CloudKitDataConnector.deleteData(database: database, entitiesToDelete: [workspace])
    }

    // MARK: Notebook
    /**
     Creates a Notebook into CloudKit
     - Parameter workspace: To what workspace it belongs.
     - Parameter name: The notebook's name.
     - Parameter colorName: The nootebook's color name.
     */
    internal func createNotebook(in workspace: CloudKitWorkspace, id: UUID, named name: String, colorName: String) -> CloudKitNotebook {
        let notebook = CloudKitNotebook(named: name, colorName: colorName, id: id)
        notebook.setWorkspace(workspace)
        workspace.appendNotebook(notebook)
        saveData(entitiesToSave: [workspace, notebook])

        return notebook
    }

    /**
     Creates a Notebook into CloudKit
     - Parameter notebook: The CoreData notebook.
     - Parameter ckWorkspace: To what workspace it belongs.
     */
    internal func createNotebook(from notebook: Notebook, in ckWorkspace: CloudKitWorkspace, shouldSave: Bool = true) -> CloudKitNotebook {
        let record = CKRecord(recordType: CloudKitNotebook.recordType)
        let ckNotebook = CloudKitNotebook(from: record)
        ckNotebook <- notebook
        ckNotebook.setWorkspace(ckWorkspace)
        ckWorkspace.appendNotebook(ckNotebook)

        if let notes = notebook.notes?.array as? [Note] {
            for note in notes {
                _ = createNote(from: note, in: ckNotebook, shouldSave: false)
            }
        }

        if shouldSave {
            saveData(entitiesToSave: [ckWorkspace, ckNotebook])
        } else {
            savingQueue.append(ckNotebook)
        }
        return ckNotebook
    }

    /**
     Deletes a notebook from CloudKit
     - Parameter notebook: Notebook to be deleted.
     */
    internal func deleteNotebook(_ notebook: CloudKitNotebook) throws {
        guard let workspace = notebook.workspace?.value else {
            throw WorkspaceError.workspaceWasNull
        }
        workspace.removeNotebook(notebook)
        saveData(entitiesToSave: [workspace], entitiesToDelete: [notebook])
    }

    // MARK: Note
    /**
     Creates a Note into CloudKit
     - Parameter notebook: To what notebook it belongs.
     */
    internal func createNote(in notebook: CloudKitNotebook, id: UUID) -> CloudKitNote {
        let note = CloudKitNote(id: id)
        note.setNotebook(notebook)
        notebook.appendNote(note)
        saveData(entitiesToSave: [notebook, note])

        return note
    }

    /**
     Creates a Note into CloudKit
     - Parameter note: The CoreData Object.
     - Parameter ckNotebook: To what notebook it belongs.
     */
    internal func createNote(from note: Note, in ckNotebook: CloudKitNotebook, shouldSave: Bool = true) -> CloudKitNote {
        let record = CKRecord(recordType: CloudKitNote.recordType)
        let ckNote = CloudKitNote(from: record)
        ckNote <- note
        ckNote.setNotebook(ckNotebook)
        ckNotebook.appendNote(ckNote)

        if let textBoxes = note.textBoxes?.allObjects as? [TextBox] {
            for textBox in textBoxes {
                _ = createTextBox(from: textBox, in: ckNote, shouldSave: false)
            }
        }

        if let imageBoxes = note.images?.allObjects as? [ImageBox] {
            for imageBox in imageBoxes {
                _ = createImageBox(from: imageBox, in: ckNote, shouldSave: false)
            }
        }

        if shouldSave {
            saveData(entitiesToSave: [ckNotebook, ckNote])
        } else {
            savingQueue.append(ckNote)
        }

        return ckNote
    }

    /**
     Deletes a note from CloudKit
     - Parameter note: Note to be deleted.
     */
    internal func deleteNote(_ note: CloudKitNote) throws {
        guard let notebook = note.notebook?.value else {
            throw NotebookError.notebookWasNull
        }
        notebook.removeNote(note)
        saveData(entitiesToSave: [notebook], entitiesToDelete: [note])
    }

    // MARK: TextBox
    /**
     Creates a TextBox into CloudKit
     - Parameter note: To what note it belongs.
     */
    internal func createTextBox(in note: CloudKitNote, id: UUID) -> CloudKitTextBox {
        let textBox = CloudKitTextBox(id: id)
        textBox.setNote(note)
        note.appendTextBox(textBox)
        saveData(entitiesToSave: [note, textBox])

        return textBox
    }

    /**
     Creates a TextBox into CloudKit
     - Parameter textBox: The CoreData object.
     - Parameter ckNote: To what note it belongs.
     */
    internal func createTextBox(from textBox: TextBox, in ckNote: CloudKitNote, shouldSave: Bool = true) -> CloudKitTextBox {
        let record = CKRecord(recordType: CloudKitTextBox.recordType)
        let ckTextBox = CloudKitTextBox(from: record)
        ckTextBox <- textBox
        ckTextBox.setNote(ckNote)
        ckNote.appendTextBox(ckTextBox)

        if shouldSave {
            saveData(entitiesToSave: [ckNote, ckTextBox])
        } else {
            savingQueue.append(ckTextBox)
        }

        return ckTextBox
    }

    /**
     Deletes a TextBox from CloudKit
     - Parameter textBox: TextBox to be deleted.
     */
    internal func deleteTextBox(_ textBox: CloudKitTextBox) throws {
        guard let note = textBox.note?.value else {
            throw NoteError.noteWasNull
        }
        note.removeTextBox(textBox)
        saveData(entitiesToSave: [note], entitiesToDelete: [textBox])
    }

    // MARK: ImageBox
    /**
     Creates a ImageBox into CloudKit
     - Parameter note: To what note it belongs.
     */
    internal func createImageBox(in note: CloudKitNote, id: UUID, at imagePath: String) -> CloudKitImageBox {
        let imageBox = CloudKitImageBox(id: id, at: imagePath)
        imageBox.setNote(note)
        note.appendImageBox(imageBox)
        saveData(entitiesToSave: [note, imageBox])

        return imageBox
    }

    /**
     Creates a ImageBox into CloudKit
     - Parameter imageBox: The CoreData object.
     - Parameter ckNote: To what note it belongs.
     */
    internal func createImageBox(from imageBox: ImageBox, in ckNote: CloudKitNote, shouldSave: Bool = true) -> CloudKitImageBox {
        let record = CKRecord(recordType: CloudKitImageBox.recordType)
        let ckImageBox = CloudKitImageBox(from: record)
        ckImageBox <- imageBox
        ckImageBox.setNote(ckNote)
        ckNote.appendImageBox(ckImageBox)

        if shouldSave {
            saveData(entitiesToSave: [ckNote, ckImageBox])
        } else {
            savingQueue.append(ckImageBox)
        }

        return ckImageBox
    }

    /**
     Deletes a ImageBox from CloudKit
     - Parameter imageBox: ImageBox to be deleted.
     */
    internal func deleteImageBox(_ imageBox: CloudKitImageBox) throws {
        guard let note = imageBox.note?.value else {
            throw NoteError.noteWasNull
        }
        note.removeImageBox(imageBox)
        saveData(entitiesToSave: [note], entitiesToDelete: [imageBox])
    }

    // MARK: Saving
    private func saveData(entitiesToSave: [CloudKitEntity] = [], entitiesToDelete: [CloudKitEntity] = []) {
        CloudKitDataConnector.saveData(database: database, entitiesToSave: entitiesToSave, entitiesToDelete: entitiesToDelete)
        savingQueue.removeAll()
    }

    // MARK: Fetches
    internal func fetchWorkspaces(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {
        CloudKitDataConnector.fetch(recordType: CloudKitWorkspace.recordType, database: database) { (answer) in
            switch answer {
            case .successful(let workspaceResults):
                if workspaceResults.isEmpty {
                    completionHandler?(.successfulWith(result: [CloudKitWorkspace]()))
                }

                //Creating all workspaces
                var workspaces: [CKRecord.ID: CloudKitWorkspace] = [:]
                for workspaceRecord in workspaceResults {
                    workspaces[workspaceRecord.recordID] = CloudKitWorkspace(from: workspaceRecord)
                }

                //Fetching all notebooks of workspaces
                self.fetchNotebooks { answer in
                    switch answer {
                    case .successfulWith(let notebooks as [CloudKitNotebook]):
                        for notebook in notebooks {
                            if let workspaceReference = notebook.record.value(forKey: "workspace") as? CKRecord.Reference,
                               let workspace = workspaces[workspaceReference.recordID] {
                                workspace.appendNotebook(notebook)
                                notebook.setWorkspace(workspace)
                            }
                        }
                        var finalWorkspaces: [CloudKitWorkspace] = []
                        finalWorkspaces.append(contentsOf: workspaces.values)
                        completionHandler?(.successfulWith(result: finalWorkspaces))
                    default:
                        completionHandler?(answer)
                    }
                }
            default:
                //Failed to fetch workspaces, back to first completion
                completionHandler?(answer)
            }
        }
    }

    internal func fetchNotebooks(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {
        //Getting all references of notebooks in workspaces
        
        CloudKitDataConnector.fetch(recordType: CloudKitNotebook.recordType, database: database) { answer in
            switch answer {
            case .successful(let notebooksResults):
                if notebooksResults.isEmpty {
                    completionHandler?(.successfulWith(result: [CloudKitNotebook]()))
                    return
                }
                //Creating all notebooks
                var notebooks: [CKRecord.ID: CloudKitNotebook] = [:]
                for notebookRecord in notebooksResults {
                    notebooks[notebookRecord.recordID] = CloudKitNotebook(from: notebookRecord)
                }

                //Fetching all notes of notebooks
                self.fetchNotes { answer in
                    switch answer {
                    case .successfulWith(let notes as [CloudKitNote]):
                        for note in notes {
                            if let notebookReference = note.record.value(forKey: "notebook") as? CKRecord.Reference,
                               let notebook = notebooks[notebookReference.recordID] {
                                notebook.appendNote(note)
                                note.setNotebook(notebook)
                            }
                        }
                        var finalNotebooks: [CloudKitNotebook] = []
                        finalNotebooks.append(contentsOf: notebooks.values)
                        completionHandler?(.successfulWith(result: finalNotebooks))
                    default:
                        completionHandler?(answer)
                    }
                }
            default:
                //Failed to fetch notebooks, back to first completion
                completionHandler?(answer)
            }
        }
    }

    internal func fetchNotes(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {

        CloudKitDataConnector.fetch(recordType: CloudKitNote.recordType, database: database) { answer in
            switch answer {
            case .successful(let noteResults):
                //Creating all the notes
                if noteResults.isEmpty {
                    completionHandler?(.successfulWith(result: [CloudKitNote]()))
                    return
                }
                var notes: [CKRecord.ID: CloudKitNote] = [:]
                for noteRecord in noteResults {
                    notes[noteRecord.recordID] = CloudKitNote(from: noteRecord)
                }

                //Checking if textbox fetched and imagebox also fetched to complete the fetch
                var didEndTextBox = false
                var didEndImageBox = false
                func didEndFetch() {
                    if didEndImageBox && didEndTextBox {
                        var finalNotes: [CloudKitNote] = []
                        finalNotes.append(contentsOf: notes.values)
                        completionHandler?(.successfulWith(result: finalNotes))
                    }
                }

                //Fetching all text boxes of notes
                self.fetchTextBoxes { answer in
                    switch answer {
                    case .successful(let results):
                        for result in results {
                            let textBox = CloudKitTextBox(from: result)
                            if let noteReference = result.object(forKey: "note") as? CKRecord.Reference,
                               let note = notes[noteReference.recordID] {
                                note.appendTextBox(textBox)
                                textBox.setNote(note)
                            }
                        }
                        didEndTextBox = true
                        didEndFetch()
                    default:
                        completionHandler?(answer)
                    }
                }
                //Fetching all image boxes of notes
                self.fetchImageBoxes { answer in
                    switch answer {
                    case .successful(let results):
                        for result in results {
                            let imageBox = CloudKitImageBox(from: result)
                            if let noteReference = result.object(forKey: "note") as? CKRecord.Reference,
                               let note = notes[noteReference.recordID] {
                                note.appendImageBox(imageBox)
                                imageBox.setNote(note)
                            }
                        }
                        didEndImageBox = true
                        didEndFetch()
                    default:
                        completionHandler?(answer)
                    }
                }
            default:
                //Failed to fetch notes, back to first completion
                completionHandler?(answer)
            }
        }
    }

    internal func fetchTextBoxes(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil) {

        CloudKitDataConnector.fetch(recordType: CloudKitTextBox.recordType, database: database) { answer in
            completionHandler?(answer)
        }
    }

    internal func fetchImageBoxes(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil) {

        CloudKitDataConnector.fetch(recordType: CloudKitImageBox.recordType, database: database) { answer in
            completionHandler?(answer)
        }
    }
}
