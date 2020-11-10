//
//  CloudKitDataController.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal class CloudKitDataController {
    private let database: DatabaseType = .Private

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
     Deletes a workspace from CoreData
     - Parameter workspace: Workspace to be deleted.
     */
    internal func deleteWorkspace(_ workspace: CloudKitWorkspace) {
        CloudKitDataConnector.deleteData(database: .Private, entitiesToDelete: [workspace])
    }

    // MARK: Notebook
    /**
     Creates a Notebook into the CoreData
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
     Deletes a notebook from CoreData
     - Parameter notebook: Notebook to be deleted.
     */
    internal func deleteNotebook(_ notebook: CloudKitNotebook) {
        notebook.workspace?.value?.removeNotebook(notebook)
        CloudKitDataConnector.deleteData(database: .Private, entitiesToDelete: [notebook])
    }

    // MARK: Saving
    private func saveData(entitiesToSave: [CloudKitEntity] = [], entitiesToDelete: [CloudKitEntity] = []) {
        CloudKitDataConnector.saveData(database: .Private, entitiesToSave: entitiesToSave, entitiesToDelete: entitiesToDelete)
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
                self.fetchNotebooks(of: workspaceResults) { answer in
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
                        break
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

    internal func fetchNotebooks(of workspaces: [CKRecord], _ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {
        //Getting all references of notebooks in workspaces
        var notebookReferences: [CKRecord.Reference] = []
        for workspace in workspaces {
            if let notebooks = workspace.value(forKey: "notebooks") as? [CKRecord.Reference] {
                notebookReferences.append(contentsOf: notebooks)
            }
        }
        CloudKitDataConnector.fetch(references: notebookReferences, recordType: CloudKitNotebook.recordType, database: database) { answer in
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
                self.fetchNotes(of: notebooksResults) { answer in
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
            break
            default:
                //Failed to fetch notebooks, back to first completion
                completionHandler?(answer)
            }
        }
    }

    internal func fetchNotes(of notebooks: [CKRecord], _ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {
        //Getting all references of notes in notebooks
        var notesReferences: [CKRecord.Reference] = []
        for notebook in notebooks {
            if let notes = notebook.value(forKey: "notes") as? [CKRecord.Reference] {
                notesReferences.append(contentsOf: notes)
            }
        }

        CloudKitDataConnector.fetch(references: notesReferences, recordType: CloudKitNote.recordType, database: database) { answer in
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
                self.fetchTextBoxes(of: noteResults) { answer in
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
                self.fetchImageBoxes(of: noteResults) { answer in
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
                break
            default:
                //Failed to fetch notes, back to first completion
                completionHandler?(answer)
            }
        }
    }

    internal func fetchTextBoxes(of notes: [CKRecord], _ completionHandler: ((DataFetchAnswer) -> Void)? = nil) {
        var textBoxesReferences: [CKRecord.Reference] = []
        for note in notes {
            if let imageBoxes = note.value(forKey: "textBoxes") as? [CKRecord.Reference] {
                textBoxesReferences.append(contentsOf: imageBoxes)
            }
        }

        CloudKitDataConnector.fetch(references: textBoxesReferences, recordType: CloudKitImageBox.recordType, database: database) { answer in
            completionHandler?(answer)
        }
    }

    internal func fetchImageBoxes(of notes: [CKRecord], _ completionHandler: ((DataFetchAnswer) -> Void)? = nil) {
        var imageBoxesReferences: [CKRecord.Reference] = []
        for note in notes {
            if let imageBoxes = note.value(forKey: "imageBoxes") as? [CKRecord.Reference] {
                imageBoxesReferences.append(contentsOf: imageBoxes)
            }
        }

        CloudKitDataConnector.fetch(references: imageBoxesReferences, recordType: CloudKitImageBox.recordType, database: database) { answer in
            completionHandler?(answer)
        }
    }
}
