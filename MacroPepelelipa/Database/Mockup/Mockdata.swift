//swiftlint:disable all
//
//  Mockdata.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if DEBUG
import UIKit

public class Mockdata {
    public static func getFullWorkspace(withName name: String? = nil, notebooksNames: [String] = [], notesTitles: [String] = []) -> WorkspaceEntity {
        let nameCopy = name ?? UUID().uuidString

        var notebooksCopy = notebooksNames
        if notebooksNames.isEmpty {
            for _ in 0...Int.random(in: 0...7) {
                notebooksCopy.append(UUID().uuidString)
            }
        }

        var notesCopy = notesTitles
        if notesTitles.isEmpty {
            for _ in 0...Int.random(in: 0...4) {
                notesCopy.append(UUID().uuidString)
            }
        }

        let workspace = Workspace(name: nameCopy)

        var notebooks: [Notebook] = []
        for notebookName in notebooksCopy {
            notebooks.append(Notebook(workspace: workspace, name: notebookName, colorName: "nb\(Int.random(in: 0...24))"))
        }

        var notes: [Note] = []
        for noteName in notesCopy {
            for notebook in notebooks {
                notes.append(Note(notebook: notebook, title: NSAttributedString(string: noteName), text: NSAttributedString()))
            }
        }

        return workspace
    }
    public static func createNote(in notebook: NotebookEntity) -> NoteEntity {
        guard let notebook = notebook as? Notebook else {
            fatalError("Failed to load mocked data")
        }
        return Note(notebook: notebook, title: NSAttributedString(), text: NSAttributedString())
    }
    public static func createWorkspace(with name: String) -> WorkspaceEntity {
        return Workspace(name: name)
    }
}
#endif
