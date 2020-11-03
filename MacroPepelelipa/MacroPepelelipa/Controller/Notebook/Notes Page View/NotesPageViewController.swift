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
    
    internal private(set) var notes: [NoteEntity] = []
    internal private(set) var notebook: NotebookEntity?
    internal private(set) var index: Int = 0
    
    private lazy var noteDataSource = NotesPageViewControllerDataSource(notes: notes)
    
    private lazy var notesToolbar: NotesToolbar = {
        let toolbar = NotesToolbar(frame: .zero)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    private lazy var noteDelegate = NotesPageViewControllerDelegate { [unowned self] (viewController) in 
        if let notesViewController = viewController as? NotesViewController {
            self.setNotesViewControllers(for: notesViewController)
        }
    }
    
    private lazy var notebookIndexButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .index, 
                                   target: self, 
                                   action: #selector(presentNotebookIndex))
        
        item.accessibilityHint = "Index button hint".localized()
        
        return item
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .done,
                                   target: self,
                                   action: #selector(closeKeyboard))
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
            
            if let name = notebook?.name {
                self.notebookIndexButton.accessibilityLabel = String(format: "Index button label".localized(), name)
            } else {
                self.notebookIndexButton.accessibilityLabel = "Index".localized()
            }
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
        navigationItem.rightBarButtonItems = [notebookIndexButton]
        
        setupNotesToolbarActions()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    ///This method configures que actions performed by the buttons at the notes toolbar 
    private func setupNotesToolbarActions() {
        
        notesToolbar.deleteNoteTriggered = {
            self.deleteNote()
        }
        
        notesToolbar.addImageTriggered = {
            if let notesViewController = self.viewControllers?.first as? NotesViewController {
                notesViewController.presentPicker()
            }
        }
        
        notesToolbar.shareNoteTriggered = { sender in
            guard let userNotebook = self.notebook else {
                return
            }
            let objectsToShare: [Any] = [userNotebook.createFullDocument()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.popoverPresentationController?.barButtonItem = sender
            self.present(activityVC, animated: true, completion: nil)
        }
        
        notesToolbar.newNoteTriggered = {
            guard let notebook = self.notebook else {
                return
            }
            
            let destination = AddNoteViewController(notebook: notebook) { 
                self.updateNotes()
            }
            
            destination.isModalInPresentation = true
            destination.modalTransitionStyle = .crossDissolve
            destination.modalPresentationStyle = .overFullScreen
            
            self.present(destination, animated: true)
        }
    }
    
    ///This method deletes the current note from the notebook 
    private func deleteNote() {
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
    
    @IBAction private func presentNotebookIndex() {
        if let presentNotebook = self.notebook {
            
            let notebookIndexViewController = NotebookIndexViewController(notebook: presentNotebook, 
                                                                          note: notes[index])
            notebookIndexViewController.observer = self
            self.present(notebookIndexViewController, animated: true, completion: nil)
        }
    }
    
    // This method is called 
    @IBAction private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Objective-C functions
    
    /// This method addes the done button when the keyboard shows.
    @objc func keyboardWillShow(_ notification: Notification) {
        if navigationItem.rightBarButtonItems?.firstIndex(of: doneButton) == nil {
            navigationItem.rightBarButtonItems?.append(doneButton)
        }
    }
    
    /// This method removes the done button when the keyboard hides.
    @objc func keyboardWillHide(_ notification: Notification) {
        if let index = navigationItem.rightBarButtonItems?.firstIndex(of: doneButton) {
            navigationItem.rightBarButtonItems?.remove(at: index)
        }
    }
    
}
