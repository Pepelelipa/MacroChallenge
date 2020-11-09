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
    internal func fetchWorkspaces(_ completionHandler: ((DataFetchAnswer) -> Void)? = nil ) {
        var workspaceObjects: [CloudKitWorkspace] = []
        CloudKitDataConnector.fetch(recordType: CloudKitWorkspace.recordType, database: database) { (answer) in
            switch answer {
            case .successful(let workspaceResults):
                //Fetching all notebooks of workspaces
                self.fetchNotebooks(of: workspaceResults)
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
                //Fetching all notes of notebooks
                self.fetchNotes(of: notebooksResults)
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
                var notes: [CKRecord.ID: CloudKitNote] = [:]
                for note in noteResults {
                    notes[note.recordID] = CloudKitNote(from: note)
                }

                //Checking if textbox fetched and imagebox also fetched
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
