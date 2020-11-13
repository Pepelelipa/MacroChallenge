//
//  DataSynchronizer.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 12/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable function_body_length cyclomatic_complexity

import Foundation

internal class DataSynchronizer {
    let queue = DispatchQueue(label: "DataSynchronizer", qos: .background, attributes: .concurrent)
    internal init(coreDataController: CoreDataController, cloudKitController: CloudKitDataController, conflictHandler: @escaping () -> ConflictHandler) {
        self.coreDataController = coreDataController
        self.cloudKitController = cloudKitController
        self.conflictHandler = conflictHandler
    }

    private var coreDataController: CoreDataController
    private var cloudKitController: CloudKitDataController
    private var conflictHandler: () -> ConflictHandler

    internal func syncWorkspaces(_ objects: inout [WorkspaceObject], ckWorkspaces: [CloudKitWorkspace]) -> [PersistentEntity] {
        var differentEntities: [PersistentEntity] = []
        var workspaces: [String: (Workspace, WorkspaceObject)] = [:]
        var ckNotebooks: [CloudKitNotebook] = []
        var notebookObjects: [NotebookObject] = []
        for object in objects {
            do {
                workspaces[try object.getID().uuidString] = (object.coreDataWorkspace, object)
                //Appending Notebooks
                if let notebooks = object.notebooks as? [NotebookObject] {
                    notebookObjects.append(contentsOf: notebooks)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }
        for ckWorkspace in ckWorkspaces {
            //Appending CKNotebooks
            if let notebooks = ckWorkspace.notebooks?.references {
                ckNotebooks.append(contentsOf: notebooks)
            }

            //Checking if already exists in CoreData, if yes just set it, else create a new CoreData from CloudKit
            if let idValue = ckWorkspace.id.value,
             let cdResult = workspaces[idValue] {
                cdResult.1.cloudKitWorkspace = ckWorkspace
                if !(cdResult.0 == ckWorkspace) {
                    differentEntities.append(cdResult.1)
                }
                workspaces.removeValue(forKey: idValue)
            } else {
                do {
                    let coreDataWorkspace = try self.coreDataController.createWorkspace(from: ckWorkspace)
                    let newWorkspace = WorkspaceObject(from: coreDataWorkspace, and: ckWorkspace)
                    objects.append(newWorkspace)
                } catch {
                    conflictHandler().errDidOccur(err: error)
                }
            }
        }

        //Each value that hasn't been removed doesn't have an online version, so create a CloudKit version
        for remainingResult in workspaces.values {
            remainingResult.1.cloudKitWorkspace = self.cloudKitController.createWorkspace(from: remainingResult.0)
        }

        differentEntities.append(contentsOf: syncNotebooks(&notebookObjects, workspaces: objects, ckNotebooks: ckNotebooks))
        return differentEntities
    }

    internal func syncNotebooks(_ objects: inout [NotebookObject], workspaces: [WorkspaceObject], ckNotebooks: [CloudKitNotebook]) -> [PersistentEntity] {
        var differentEntities: [PersistentEntity] = []
        var notebooks: [String: (Notebook, NotebookObject)] = [:]
        var ckNotes: [CloudKitNote] = []
        var noteObjects: [NoteObject] = []
        for object in objects {
            do {
                notebooks[try object.getID().uuidString] = (object.coreDataNotebook, object)
                //Appending Notes
                if let notes = object.notes as? [NoteObject] {
                    noteObjects.append(contentsOf: notes)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }
        for ckNotebook in ckNotebooks {
            //Appending CKNotes
            if let notes = ckNotebook.notes?.references {
                ckNotes.append(contentsOf: notes)
            }

            //Checking if already exists in CoreData, if yes just set it, else create a new CoreData from CloudKit
            if let idValue = ckNotebook.id.value,
               let cdResult = notebooks[idValue] {
                cdResult.1.cloudKitNotebook = ckNotebook
                if !(cdResult.0 == ckNotebook) {
                    differentEntities.append(cdResult.1)
                }
                notebooks.removeValue(forKey: idValue)
            } else {
                do {
                    if let workspaceID = ckNotebook.workspace?.value?.id,
                       let workspaceObject = try workspaces.first(where: { try $0.getID().uuidString == workspaceID }) {
                        let coreDataNotebook = try self.coreDataController.createNotebook(from: ckNotebook, in: workspaceObject.coreDataWorkspace)
                        let newNotebook = NotebookObject(in: workspaceObject, from: coreDataNotebook, and: ckNotebook)
                        objects.append(newNotebook)
                    } else {
                        conflictHandler().errDidOccur(err: WorkspaceError.workspaceWasNull)
                    }
                } catch {
                    conflictHandler().errDidOccur(err: error)
                }
            }
        }

        //Each value that hasn't been removed doesn't have an online version, so create a CloudKit version
        for remainingResult in notebooks.values {
            do {
                if let workspace = try workspaces.first(where: { try $0.getID().uuidString == remainingResult.0.id?.uuidString })?.cloudKitWorkspace {
                    remainingResult.1.cloudKitNotebook = self.cloudKitController.createNotebook(from: remainingResult.0, in: workspace)
                } else {
                    conflictHandler().errDidOccur(err: WorkspaceError.workspaceWasNull)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }

        differentEntities.append(contentsOf: syncNotes(&noteObjects, notebooks: objects, ckNotes: ckNotes))

        return differentEntities
    }

    internal func syncNotes(_ objects: inout [NoteObject], notebooks: [NotebookObject], ckNotes: [CloudKitNote]) -> [PersistentEntity] {
        var differentEntities: [PersistentEntity] = []
        var notes: [String: (Note, NoteObject)] = [:]
        var ckTextBoxes: [CloudKitTextBox] = []
        var textBoxObjects: [TextBoxObject] = []
        var ckImageBoxes: [CloudKitImageBox] = []
        var imageBoxObjects: [ImageBoxObject] = []

        for object in objects {
            do {
                notes[try object.getID().uuidString] = (object.coreDataNote, object)
                //Appending Text Boxes
                if let textBoxes = object.textBoxes as? [TextBoxObject] {
                    textBoxObjects.append(contentsOf: textBoxes)
                }
                //Appending Image Boxes
                if let imageBoxes = object.images as? [ImageBoxObject] {
                    imageBoxObjects.append(contentsOf: imageBoxes)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }
        for ckNote in ckNotes {
            //Appending CKTextBoxes
            if let textBoxes = ckNote.textBoxes?.references {
                ckTextBoxes.append(contentsOf: textBoxes)
            }
            //Appending CKImageBoxes
            if let imageBoxes = ckNote.imageBoxes?.references {
                ckImageBoxes.append(contentsOf: imageBoxes)
            }

            //Checking if already exists in CoreData, if yes just set it, else create a new CoreData from CloudKit
            if let idValue = ckNote.id.value,
               let cdResult = notes[idValue] {
                cdResult.1.cloudKitNote = ckNote
                if !(cdResult.0 == ckNote) {
                    differentEntities.append(cdResult.1)
                }
                notes.removeValue(forKey: idValue)
            } else {
                do {
                    if let notebookID = ckNote.notebook?.value?.id,
                       let notebookObject = try notebooks.first(where: { try $0.getID().uuidString == notebookID }) {
                        let coreDataNote = try self.coreDataController.createNote(from: ckNote, in: notebookObject.coreDataNotebook)
                        let newNote = NoteObject(in: notebookObject, from: coreDataNote, and: ckNote)
                        objects.append(newNote)
                    } else {
                        conflictHandler().errDidOccur(err: NotebookError.notebookWasNull)
                    }
                } catch {
                    conflictHandler().errDidOccur(err: error)
                }
            }
        }

        //Each value that hasn't been removed doesn't have an online version, so create a CloudKit version
        for remainingResult in notes.values {
            do {
                if let notebook = try notebooks.first(where: { try $0.getID().uuidString == remainingResult.0.id?.uuidString })?.cloudKitNotebook {
                    remainingResult.1.cloudKitNote = self.cloudKitController.createNote(from: remainingResult.0, in: notebook)
                } else {
                    conflictHandler().errDidOccur(err: NotebookError.notebookWasNull)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }

        let group = DispatchGroup()
        group.enter()
        group.enter()

        let objectsCopy = objects
        queue.async {
            differentEntities.append(contentsOf: self.syncTextBoxes(&textBoxObjects, notes: objectsCopy, ckTextBoxes: ckTextBoxes))
            group.leave()
        }
        queue.async {
            differentEntities.append(contentsOf: self.syncImageBoxes(&imageBoxObjects, notes: objectsCopy, ckImageBoxes: ckImageBoxes))
            group.leave()
        }

        group.wait()

        return differentEntities
    }

    internal func syncTextBoxes(_ objects: inout [TextBoxObject], notes: [NoteObject], ckTextBoxes: [CloudKitTextBox]) -> [PersistentEntity] {
        var differentEntities: [PersistentEntity] = []
        var textBoxes: [String: (TextBox, TextBoxObject)] = [:]

        for object in objects {
            do {
                textBoxes[try object.getID().uuidString] = (object.coreDataTextBox, object)
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }
        for ckTextBox in ckTextBoxes {
            //Checking if already exists in CoreData, if yes just set it, else create a new CoreData from CloudKit
            if let idValue = ckTextBox.id.value,
               let cdResult = textBoxes[idValue] {
                cdResult.1.cloudKitTextBox = ckTextBox
                if !(cdResult.0 == ckTextBox) {
                    differentEntities.append(cdResult.1)
                }
                textBoxes.removeValue(forKey: idValue)
            } else {
                do {
                    if let noteID = ckTextBox.note?.value?.id,
                       let noteObject = try notes.first(where: { try $0.getID().uuidString == noteID }) {
                        let coreDataTextBox = try self.coreDataController.createTextBox(from: ckTextBox, in: noteObject.coreDataNote)
                        let newTextBox = TextBoxObject(in: noteObject, from: coreDataTextBox, and: ckTextBox)
                        objects.append(newTextBox)
                    } else {
                        conflictHandler().errDidOccur(err: NoteError.noteWasNull)
                    }
                } catch {
                    conflictHandler().errDidOccur(err: error)
                }
            }
        }

        //Each value that hasn't been removed doesn't have an online version, so create a CloudKit version
        for remainingResult in textBoxes.values {
            do {
                if let note = try notes.first(where: { try $0.getID().uuidString == remainingResult.0.id?.uuidString })?.cloudKitNote {
                    remainingResult.1.cloudKitTextBox = self.cloudKitController.createTextBox(from: remainingResult.0, in: note)
                } else {
                    conflictHandler().errDidOccur(err: NoteError.noteWasNull)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }

        return differentEntities
    }

    internal func syncImageBoxes(_ objects: inout [ImageBoxObject], notes: [NoteObject], ckImageBoxes: [CloudKitImageBox]) -> [PersistentEntity] {
        var differentEntities: [PersistentEntity] = []
        var imageBoxes: [String: (ImageBox, ImageBoxObject)] = [:]

        for object in objects {
            do {
                imageBoxes[try object.getID().uuidString] = (object.coreDataImageBox, object)
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }
        for ckImageBox in ckImageBoxes {
            //Checking if already exists in CoreData, if yes just set it, else create a new CoreData from CloudKit
            if let idValue = ckImageBox.id.value,
               let cdResult = imageBoxes[idValue] {
                cdResult.1.cloudKitImageBox = ckImageBox
                if !(cdResult.0 == ckImageBox) {
                    differentEntities.append(cdResult.1)
                }
                imageBoxes.removeValue(forKey: idValue)
            } else {
                do {
                    if let noteID = ckImageBox.note?.value?.id,
                       let noteObject = try notes.first(where: { try $0.getID().uuidString == noteID }) {
                        let coreDataImageBox = try self.coreDataController.createImageBox(from: ckImageBox, in: noteObject.coreDataNote)
                        let newImageBox = ImageBoxObject(in: noteObject, from: coreDataImageBox, and: ckImageBox)
                        objects.append(newImageBox)
                    } else {
                        conflictHandler().errDidOccur(err: NoteError.noteWasNull)
                    }
                } catch {
                    conflictHandler().errDidOccur(err: error)
                }
            }
        }

        //Each value that hasn't been removed doesn't have an online version, so create a CloudKit version
        for remainingResult in imageBoxes.values {
            do {
                if let note = try notes.first(where: { try $0.getID().uuidString == remainingResult.0.id?.uuidString })?.cloudKitNote {
                    remainingResult.1.cloudKitImageBox = self.cloudKitController.createImageBox(from: remainingResult.0, in: note)
                } else {
                    conflictHandler().errDidOccur(err: NoteError.noteWasNull)
                }
            } catch {
                conflictHandler().errDidOccur(err: error)
            }
        }

        return differentEntities
    }
}
