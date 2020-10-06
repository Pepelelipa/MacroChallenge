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
    private lazy var noteDataSource = NotesPageViewControllerDataSource(notesViewControllers: notesViewControllers)
    
    internal private(set) lazy var notesViewControllers: [NotesViewController] = {
        var viewControllers: [NotesViewController] = []
        for i in 0..<self.notes.count {
            viewControllers.append(NotesViewController(note: notes[i]))
        }
        return viewControllers
    }()
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: .none)
    }

    internal convenience required init?(coder: NSCoder) {
        guard let notes = coder.decodeObject(forKey: "notes") as? [NoteEntity] else {
            return nil
        }
        self.init(notes: notes)
    }

    override func viewDidLoad() {
        self.dataSource = noteDataSource
        if let firstViewController = notesViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        view.backgroundColor = .clear
    }
}
