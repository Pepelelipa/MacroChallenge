//
//  NotesPageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 05/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    private var notes: [NoteEntity]?
    
    internal lazy var notesViewControllers: [NotesViewController] = {
        
        var viewControllers: [NotesViewController] = []
        
        if let notebookNotes = notes {
            
            for i in 0..<notebookNotes.count {
                viewControllers.append(NotesViewController(note: notebookNotes[i]))
            }
        }
        
         return viewControllers
    }()
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = notesViewControllers.firstIndex(where: { $0 === viewController }),
           currentIndex - 1 > -1 {
            return notesViewControllers[currentIndex - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = notesViewControllers.firstIndex(where: { $0 === viewController }),
           currentIndex + 1 < notesViewControllers.count {
            return notesViewControllers[currentIndex + 1]
        }
        return nil
    }
    
    func indexFor(_ viewController: UIViewController?) -> Int? {
        return notesViewControllers.firstIndex(where: { $0 === viewController })
    }
 }

