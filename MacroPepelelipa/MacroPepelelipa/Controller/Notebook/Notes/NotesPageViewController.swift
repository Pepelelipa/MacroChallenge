//
//  NotesPageViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesPageViewController: UIPageViewController {
    
    internal private(set) var notes: [NoteEntity] = []
    private var notesViewControllers: [NotesViewController] = []
    private lazy var noteDataSource = NotesPageViewControllerDataSource(notes: notes)
    private lazy var noteDelegate = NotesPageViewControllerDelegate { [unowned self] (viewController) in 
        if let notesViewController = viewController as? NotesViewController {
            self.setNotesViewControllers(for: notesViewController)
        }
    }
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: .none)
        setNotesViewControllers(for: NotesViewController(note: notes[notes.count-1]))
    }

    internal convenience required init?(coder: NSCoder) {
        guard let notes = coder.decodeObject(forKey: "notes") as? [NoteEntity] else {
            return nil
        }
        self.init(notes: notes)
    }

    override func viewDidLoad() {
        self.dataSource = noteDataSource
        self.delegate = noteDelegate
        
        if let viewController = notes.count > 2 ? notesViewControllers[1] : notesViewControllers.first {
            setViewControllers([viewController], direction: .forward, animated: true)
        }
        
        view.backgroundColor = .clear
    }
    
    private func setupPageView() {
        
        if let viewController = notes.count > 2 ? notesViewControllers[1] : notesViewControllers.first {
            setViewControllers([viewController], direction: .forward, animated: true)
        }
    }
    
    internal func setNotesViewControllers(for notesViewController: NotesViewController, fromIndex: Bool = false) {
        var index: Int = 0
        
        for i in 0..<self.notes.count where notesViewController.note === notes[i] {
            index = i
        }
        
        var viewControllers: [NotesViewController] = []
        
        if index - 1 > -1 {
            viewControllers.append(NotesViewController(note: notes[index-1]))
        }
        
        viewControllers.append(notesViewController)
        
        if index + 1 < notes.count {
            viewControllers.append(NotesViewController(note: notes[index+1]))
        }
        
        self.notesViewControllers = viewControllers
        
        if !fromIndex {
            if let viewController = viewControllers.count > 2 ? notesViewControllers[1] : notesViewControllers.first {
                setViewControllers([viewController], direction: .forward, animated: true)
            }
        } else {
            setViewControllers([notesViewController], direction: .forward, animated: true)
        }
    }
}
