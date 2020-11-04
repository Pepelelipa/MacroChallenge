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
import Dispatch

internal struct SpotlightController {
    
    static private func searchableItemAttributes(title: String, displayName: String, description: String) -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributes.title = title
        attributes.displayName = displayName
        attributes.contentDescription = description
        
        attributes.providerDataTypeIdentifiers = [kUTTypeUTF8PlainText as String]
        attributes.providerFileTypeIdentifiers = [kUTTypeImage as String]
        
        return attributes
    }
    
    static internal func createSearchableNote(note: NoteEntity) {
        let attributes = self.searchableItemAttributes(title: note.title.string, displayName: note.title.string, description: note.text.string)
        do {
            let identifier = try note.getID().uuidString
            let item = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: "PEPELELIPA.Macro", attributeSet: attributes)
            
            CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } catch {
            fatalError()
        }
    }
    
    static internal func deleteSearchableNote(note: NoteEntity) {
        do {
            let identifier = try note.getID().uuidString
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [identifier]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } catch {
            fatalError()
        }
    }
    
    static internal func editSearchableNote(note: NoteEntity) {
        self.deleteSearchableNote(note: note)
        self.createSearchableNote(note: note)
    }
}
