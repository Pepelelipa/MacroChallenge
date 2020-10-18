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
    
    private var notesEntities: [NoteEntity]?
    
    internal init(notes: [NoteEntity]) {
        self.notesEntities = notes
        super.init()
        DataManager.shared().addCreationObserver(self, type: .note)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesEntities,
           let notesViewController = viewController as? NotesViewController,
           let currentIndex = notes.firstIndex(where: { $0 === notesViewController.note }),
           currentIndex - 1 > -1 {
            return NotesViewController(note: notes[currentIndex-1])
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesEntities,
           let notesViewController = viewController as? NotesViewController,
           let currentIndex = notes.firstIndex(where: { $0 === notesViewController.note }),
           currentIndex + 1 < notes.count {
            return NotesViewController(note: notes[currentIndex+1])
        }
        return nil
    }
    
    func indexFor(_ viewController: UIViewController?) -> Int? {
        
        if let notes = notesEntities,
           let notesViewController = viewController as? NotesViewController,
           let currentIndex = notes.firstIndex(where: { $0 === notesViewController.note }) {
            return currentIndex
        }
        return nil
    }
    
    func entityWasCreated(_ value: ObservableEntity) {
        if let note = value as? NoteEntity {
            note.addObserver(self)
            self.notesEntities?.append(note)
        }
    }
    
    func entityShouldDelete(_ value: ObservableEntity) {
        if let note = value as? WorkspaceEntity,
           let index = self.notesEntities?.firstIndex(where: { $0 === note }) {
            note.removeObserver(self)
            self.notesEntities?.remove(at: index)
        }
    }
    
 }
