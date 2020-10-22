//
//  NotesPageViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesPageViewController: UIPageViewController, 
                                        IndexObserver,
                                        ImageButtonObserver {
    
    // MARK: - Variables and Constants
    
    private var notesViewControllers: [NotesViewController] = []
    private weak var observer: NotesPageViewObserver?
    
    private lazy var notesToolbar: NotesToolbar = {
        let toolbar = NotesToolbar(frame: CGRect(x: 100, y: 100, width: self.view.frame.width, height: 0))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    internal private(set) var notes: [NoteEntity] = []
    internal private(set) var notebook: NotebookEntity?
    internal private(set) var index: Int = 0
    
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

    private lazy var constraints: [NSLayoutConstraint] = {
        [
            notesToolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notesToolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notesToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    // MARK: - Initializers
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: .none)
        setNotesViewControllers(for: NotesViewController(note: notes[notes.count-1]))
        
        do {
            self.notebook = try notes[0].getNotebook()
        } catch {
            let alertController = UIAlertController(
                title: "Error retriving notebook".localized(),
                message: "The app could not retrieve a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook could not be retrieved".localized())

            self.present(alertController, animated: true, completion: nil)
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
        
        view.addSubview(notesToolbar)
        
        view.backgroundColor = .rootColor
        
        navigationItem.largeTitleDisplayMode = .never
        if (try? notes.first?.getNotebook().getWorkspace().isEnabled) ?? false {
            navigationItem.rightBarButtonItems = [addNewNoteButton, moreActionsButton, notebookIndexButton]
        } else {
            navigationItem.rightBarButtonItems = [notebookIndexButton]
        }
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    /**
     This method sets the NotesViewController for the NotesPageViewController. To optimize, the NotesPageViewController can hold the maximum 
     of 3 NotesViewController: the one being presented, the previous one and the next one. At least one NotesViewController will aways be setted 
     (the presenting one). This functions is called everytime that the presenting NotesViewController is changed.
     - Parameter notesViewController: A NotesViewController displaying a note from a notebook.
     */
    internal func setNotesViewControllers(for notesViewController: NotesViewController) {
        
        index = 0
        
        for i in 0..<self.notes.count where notesViewController.note === notes[i] {
            index = i
        }
        
        var viewControllers: [NotesViewController] = []
        
        if index - 1 > -1 {
            viewControllers.append(NotesViewController(note: notes[index-1]))
        }
        
        viewControllers.append(notesViewController)
        notesViewController.imgeButtonObserver = self
        
        if index + 1 < notes.count {
            viewControllers.append(NotesViewController(note: notes[index+1]))
        }
        
        self.notesViewControllers = viewControllers
        
        let viewControllerToBePresented = viewControllers.first == notesViewController ? 
            notesViewControllers.first : notesViewControllers[1]
        
        if let viewController = viewControllers.count > 2 ? notesViewControllers[1] : viewControllerToBePresented {
            setViewControllers([viewController], direction: .forward, animated: false)
        }
    }
    
    internal func updateNotes() {
        if let updatedNotebook = notebook {
            notes = updatedNotebook.notes
            if let lastNote = notes.last {
                setNotesViewControllers(for: NotesViewController(note: lastNote))
            }
        }
    }

    ///Tries to remove the presenting note, returns true if success, returns false if it was the only view controller being presented.
    internal func removePresentingNote(note: NoteEntity) -> Bool {
        if let notesIndex = self.notesViewControllers.firstIndex(where: { $0.note === note }) {
            self.notesViewControllers.remove(at: notesIndex)
            if self.notesViewControllers.isEmpty {
                return false
            } else {
                self.updateNotes()
                return true
            }
        }
        return false
    }
    
    // MARK: - IndexObserver functions
    
    internal func didChangeIndex(to note: NoteEntity) {
        setNotesViewControllers(for: NotesViewController(note: note))
    }
    
    // MARK: - ImageButtonObserver functions
    
    internal func showImageButton() {
        self.notesToolbar.isHidden = false
    }
    
    internal func hideImageButton() {
        self.notesToolbar.isHidden = true
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func addNewNote() {
        guard let guardedNotebook = notebook else {
            return
        }
        addNewNoteButton.isEnabled = false
        let addController = AddNoteViewController(notebook: guardedNotebook, dismissHandler: {
            self.updateNotes()
            self.addNewNoteButton.isEnabled = true
        })
        addController.moveTo(self)
    }
    
    @IBAction private func presentMoreActions() {
        guard let viewController = viewControllers?.first as? NotesViewController,
            let note = viewController.note else {
            return
        }
        let alertControlller = UIAlertController(
            title: "Delete Note confirmation".localized(),
            message: "Warning".localized(),
            preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .note) { _ in
            let deleteAlertController = UIAlertController(
                title: "Delete note confirmation".localized(),
                message: "Warning".localized(),
                preferredStyle: .alert).makeDeleteConfirmation(dataType: .note) { _ in
                do {
                    try DataManager.shared().deleteNote(note)
                    viewController.shouldSave = false
                    if !self.removePresentingNote(note: note) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    let alertController = UIAlertController(
                        title: "Could not delete this note".localized(),
                        message: "The app could not delete the note".localized() + note.title.string,
                        preferredStyle: .alert)
                        .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            self.present(deleteAlertController, animated: true, completion: nil)
        }
        self.present(alertControlller, animated: true, completion: nil)
    }
    
    @IBAction private func presentNotebookIndex() {
        if let presentNotebook = self.notebook {
            
            let notebookIndexViewController = NotebookIndexViewController(notebook: presentNotebook, 
                                                                          note: notes[index])
            notebookIndexViewController.observer = self
            
            self.present(notebookIndexViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func presentPicker() {
        if let notesViewController = self.viewControllers?.first as? NotesViewController {
            notesViewController.presentPicker()
        }
    }
    
}
