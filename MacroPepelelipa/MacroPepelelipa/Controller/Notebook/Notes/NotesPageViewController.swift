//
//  NotesPageViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesPageViewController: UIPageViewController, IndexObserver {
    
    // MARK: - Variables and Constants
    
    private var notesViewControllers: [NotesViewController] = []
    
    internal private(set) var notes: [NoteEntity] = []
    internal private(set) var notebook: NotebookEntity?
    
    private lazy var noteDataSource = NotesPageViewControllerDataSource(notes: notes)
    
    private lazy var noteDelegate = NotesPageViewControllerDelegate { [unowned self] (viewController) in 
        if let notesViewController = viewController as? NotesViewController {
            self.setNotesViewControllers(for: notesViewController)
        }
    }
    
    private lazy var addNewNoteButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .addNote, 
                                   target: self, 
                                   action: #selector(addNewNote))
        return item
    }()
    
    private lazy var moreActionsButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .moreActions, 
                                   target: self, 
                                   action: #selector(presentMoreActions))
        return item
    }()
    
    private lazy var notebookIndexButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .index, 
                                   target: self, 
                                   action: #selector(presentNotebookIndex))
        return item
    }()
    
    // MARK: - Initializers
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: .none)
        setNotesViewControllers(for: NotesViewController(note: notes[notes.count-1]))
        
        do {
            self.notebook = try notes[0].getNotebook()
        } catch {
            fatalError("Error retriving notebook")
        }
    }
    
    internal convenience required init?(coder: NSCoder) {
        guard let notes = coder.decodeObject(forKey: "notes") as? [NoteEntity] else {
            return nil
        }
        self.init(notes: notes)
    }
    
    // MARK: - Override functions

    override func viewDidLoad() {
        self.dataSource = noteDataSource
        self.delegate = noteDelegate
        navigationItem.rightBarButtonItems = [addNewNoteButton, moreActionsButton, notebookIndexButton]
        view.backgroundColor = .rootColor
    }
    
    // MARK: - Functions
    
    /**
     This method sets the NotesViewController for the NotesPageViewController. To optimize, the NotesPageViewController can hold the maximum 
     of 3 NotesViewController: the one being presented, the previous one and the next one. At least one NotesViewController will aways be setted 
     (the presenting one). This functions is called everytime that the presenting NotesViewController is changed.
     - Parameter notesViewController: A NotesViewController displaying a note from a notebook.
     */
    internal func setNotesViewControllers(for notesViewController: NotesViewController) {
        
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
        
        let viewControllerToBePresented = viewControllers.first == notesViewController ? notesViewControllers.first : notesViewControllers[1]
        
        if let viewController = viewControllers.count > 2 ? notesViewControllers[1] : viewControllerToBePresented {
            setViewControllers([viewController], direction: .forward, animated: false)
        }
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func addNewNote() {
        guard let guardedNotebook = notebook else {
            return
        }
        addNewNoteButton.isEnabled = false
        let addController = AddNoteViewController(notebook: guardedNotebook, dismissHandler: {
            
            self.setNotesViewControllers(for: NotesViewController(note: self.notes[self.notes.count-1]))
            self.addNewNoteButton.isEnabled = true
        })
        addController.moveTo(self)
    }
    
    @IBAction private func presentMoreActions() {
        // TODO: present more actions button
    }
    
    @IBAction private func presentNotebookIndex() {
        if let presentNotebook = self.notebook {
            
            let notebookIndexViewController = NotebookIndexViewController(notebook: presentNotebook)
            notebookIndexViewController.observer = self
            
            self.present(notebookIndexViewController, animated: true, completion: nil)
        }
    }
    
    func didChangeIndex(to note: NoteEntity) {
        setNotesViewControllers(for: NotesViewController(note: note))
    }
}
