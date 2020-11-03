//
//  SpotlightController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 30/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import Database

internal struct SpotlightController {
    
//    private var workspaces: [WorkspaceEntity] = {
//        do {
//            let workspaces = try Database.DataManager.shared().fetchWorkspaces()
//            return workspaces
//        } catch {
//            fatalError("Sorry not sorry")
//        }
//        return []
//    }()
//    
//    private lazy var notebooks: [NotebookEntity] = {
//        var notebooksArray = [NotebookEntity]()
//        
//        self.workspaces.forEach { (workspace) in
//            notebooksArray.append(contentsOf: workspace.notebooks)
//        }
//        return notebooksArray
//    }()
//    
//    private lazy var notes: [NoteEntity] = {
//        var notesArray = [NoteEntity]()
//        
//        self.notebooks.forEach { (notebook) in
//            notesArray.append(contentsOf: notebook.notes)
//        }
//        return notesArray
//    }()
//    
    static private func searchableItemAttributes(title: String, displayName: String, description: String) -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributes.title = title
        attributes.displayName = displayName
        attributes.contentDescription = description
        
        attributes.providerDataTypeIdentifiers = [kUTTypeUTF8PlainText as String]
        attributes.providerFileTypeIdentifiers = [kUTTypeImage as String]
        
        return attributes
    }
    
    static internal func createSearchableNote(note: NoteEntity, identifier: String) {
        let attributes = self.searchableItemAttributes(title: note.title.string, displayName: note.text.string, description: note.text.string)
        let item = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: "PEPELELIPA.Macro", attributeSet: attributes)
        
        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static internal func deleteSearchableNote(note: NoteEntity, identifier: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [identifier]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static internal func editSearchableNote(note: NoteEntity) {
        

    }
}
