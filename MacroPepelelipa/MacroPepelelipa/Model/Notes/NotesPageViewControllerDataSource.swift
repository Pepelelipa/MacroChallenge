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
    
    private var notesViewControllers: [NotesViewController]?
    
    internal init(notesViewControllers: [NotesViewController]) {
        self.notesViewControllers = notesViewControllers
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesViewControllers, 
           let currentIndex = notes.firstIndex(where: { $0 === viewController }),
           currentIndex - 1 > -1 {
            return notes[currentIndex - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let notes = notesViewControllers, 
           let currentIndex = notes.firstIndex(where: { $0 === viewController }),
           currentIndex + 1 < notes.count {
            return notes[currentIndex + 1]
        }
        return nil
    }
    
    func indexFor(_ viewController: UIViewController?) -> Int? {
        if let currentIndex = notesViewControllers?.firstIndex(where: { $0 === viewController }) {
            return currentIndex
        }
        return nil
    }
    
 }
