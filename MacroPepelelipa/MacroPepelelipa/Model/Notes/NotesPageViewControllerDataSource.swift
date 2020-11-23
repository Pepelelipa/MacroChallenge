//
//  NotesPageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 05/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesPageViewControllerDataSource: NSObject, 
                                                  UIPageViewControllerDataSource, 
                                                  EntityObserver {
    
    // MARK: - Variables and Constants
    
    private var notesEntities: [NoteEntity]?
    
    // MARK: - Initializers
    
    internal init(notes: [NoteEntity]) {
        self.notesEntities = notes
        super.init()
        DataManager.shared().addCreationObserver(self, type: .note)
    }
    
    // MARK: - PageViewControllerDataSource functions

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesEntities,
           let notesViewController = viewController as? NotesViewController,
           let currentIndex = notes.firstIndex(where: { $0 === notesViewController.note }),
           currentIndex - 1 > -1 {
            return NotesViewController(note: notes[currentIndex-1])
        }
        return nil
    }

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesEntities,
           let notesViewController = viewController as? NotesViewController,
           let currentIndex = notes.firstIndex(where: { $0 === notesViewController.note }),
           currentIndex + 1 < notes.count {
            return NotesViewController(note: notes[currentIndex+1])
        }
        return nil
    }
    
    // MARK: - EntityObserver functions
    
    internal func entityWasCreated(_ value: ObservableEntity) {
        if let note = value as? NoteEntity {
            note.addObserver(self)
            self.notesEntities?.append(note)
        }
    }
    
    internal func entityShouldDelete(_ value: ObservableEntity) {
        if let note = value as? NoteEntity,
           let index = self.notesEntities?.firstIndex(where: { $0 === note }) {
            note.removeObserver(self)
            self.notesEntities?.remove(at: index)
        }
    }

    internal func entityWithIDShouldDelete(_ value: String) -> ObservableEntity? {
        if let index = self.notesEntities?.firstIndex(where: { (try? $0.getID())?.uuidString == value }),
           let note = self.notesEntities?[index] {
            self.notesEntities?[index].removeObserver(self)
            self.notesEntities?.remove(at: index)
            return note
        }
        return nil
    }
    
 }
