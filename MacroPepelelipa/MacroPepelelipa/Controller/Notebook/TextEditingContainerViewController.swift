//
//  TextEditingContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable multiple_closures_with_trailing_closure

import UIKit
import Database
import PhotosUI

internal class TextEditingContainerViewController: UIViewController, 
                                                   IndexObserver, 
                                                   MarkupToolBarObserver {
    
    // MARK: - Variables and Constants
    
    private var centerViewController: NotesPageViewController?
    private weak var rightViewController: NotebookIndexViewController?
    
    private var movement: CGFloat?
    internal var widthConstraint: NSLayoutConstraint?
    
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
    
    private lazy var notesViewController = centerViewController?.viewControllers?.first as? NotesViewController
    
    internal lazy var markupConfig: MarkupBarConfiguration = {
        guard let textView = notesViewController?.textView else {
            fatalError("Controller not found")
        }
        let mrkConf = MarkupBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    private lazy var markupNavigationView: MarkupNavigationView = {
        let mrkView = MarkupNavigationView(frame: .zero, configurations: markupConfig)
        mrkView.backgroundColor = UIColor.backgroundColor
        
        return mrkView
    }()
    
    // MARK: - Initializers
    
    internal init(centerViewController: NotesPageViewController) {
        self.centerViewController = centerViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    internal convenience required init?(coder: NSCoder) {
        guard let centerViewController = coder.decodeObject(forKey: "centerViewController") as? NotesPageViewController else {
            return nil
        }
        self.init(centerViewController: centerViewController)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let centerViewController = self.centerViewController {
            showCenterViewController(centerViewController)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
        navigationItem.rightBarButtonItems = [addNewNoteButton, moreActionsButton, notebookIndexButton]
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = markupNavigationView
        navigationItem.titleView?.backgroundColor = .clear
        view.backgroundColor = .rootColor
    }
    
    // MARK: - Functions
    
    /**
     This method instaciates NotebookIndexViewController and peform an animation to show it.
     - Parameter notebook: The current notebook
     */
    private func showIndex(for notebook: NotebookEntity) {
        
        guard let index = centerViewController?.index,
              let note = centerViewController?.notes[index] else {
            return
        }
        
        let rightViewController = NotebookIndexViewController(notebook: notebook, note: note)
        rightViewController.observer = self
        rightViewController.willMove(toParent: self)
        addChild(rightViewController)
        
        let rightView: UIView = rightViewController.view
        rightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightView)
        rightView.frame = CGRect(x: view.frame.maxX, y: view.frame.maxY, width: 0, height: view.frame.height)

        let widthConstraint = rightView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        self.widthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            widthConstraint,
            rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightView.topAnchor.constraint(equalTo: view.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        rightViewController.didMove(toParent: self)
        self.movement = view.frame.width * 0.4

        UIView.animate(withDuration: 0.5) {
            for child in self.view.subviews {
                child.frame.origin.x -= self.view.frame.width * 0.4
            }
        }

        self.rightViewController = rightViewController
    }
    
    /**
     This method peforms an animation to hide the NotebookIndexViewController.
     - Parameter rightViewController: the presenting NotebookIndexViewController.
     */
    private func hideIndex(_ rightViewController: NotebookIndexViewController) {
        UIView.animate(withDuration: 0.5) {
            for child in self.view.subviews {
                child.frame.origin.x += self.movement ?? rightViewController.view.frame.width
            }
        } completion: { _ in
            rightViewController.willMove(toParent: nil)
            rightViewController.removeFromParent()
            rightViewController.view.removeFromSuperview()
            rightViewController.didMove(toParent: nil)
        }

        self.rightViewController = nil
    }
    
    /**
     This method removes a NotesViewController and instaciates a new one.
     - Parameter centerViewController: The current centerViewController.
     */
    private func showCenterViewController(_ centerViewController: NotesPageViewController) {
        
        self.centerViewController?.willMove(toParent: nil)
        self.centerViewController?.removeFromParent()
        self.centerViewController?.view.removeFromSuperview()
        self.centerViewController?.didMove(toParent: nil)
        
        self.centerViewController = centerViewController
        centerViewController.willMove(toParent: self)
        addChild(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMove(toParent: self)
    }
    
    ///This method opens the pop over when the button is pressed
    internal func openPopOver() {
        guard let textView = notesViewController?.textView,
              let formatViewDelegate = notesViewController?.formatViewDelegate,
              let textViewDelegate = notesViewController?.textViewDelegate else {
            return
        }
        
        let markupContainerViewController = MarkupContainerViewController(owner: textView,
                                                                          delegate: formatViewDelegate,
                                                                          viewController: notesViewController,
                                                                          size: .init(width: 380, height: 110))
        
        if let formatView = markupContainerViewController.formatView {
            formatViewDelegate.setFormatView(formatView)
            textViewDelegate.setFotmatView(formatView)
        }
        
        markupContainerViewController.modalPresentationStyle = .popover
        markupContainerViewController.popoverPresentationController?.sourceView = markupNavigationView.barButtonItems[4]
        
        present(markupContainerViewController, animated: true)
    }
    
    // MARK: - IndexObserver functions
    
    internal func didChangeIndex(to note: NoteEntity) {
        if let rightViewController = rightViewController,
           let centerViewController = centerViewController {
            
            centerViewController.setNotesViewControllers(for: NotesViewController(note: note))
            
            hideIndex(rightViewController)
        }
    }
    
    // MARK: - MarkupToolBarObserver functions
    
    internal func createTextBox(transcription: String?) {
        if let noteController = centerViewController?.viewControllers?.first as? NotesViewController {
            noteController.createTextBox(transcription: transcription)
        }
    }

    internal func presentPicker() {
        guard let noteController = centerViewController?.viewControllers?.first as? NotesViewController else {
            return
        }
        
        #if !targetEnvironment(macCatalyst)
        
        var config = PHPickerConfiguration()
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)

        picker.delegate = noteController.photoPickerDelegate

        present(picker, animated: true, completion: nil)
        
        #endif
    }

    internal func changeTextViewInput(isCustom: Bool) {
        if let noteController = centerViewController?.viewControllers?.first as? NotesViewController {
            noteController.changeTextViewInput(isCustom: isCustom)
        }
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func addNewNote() {
        guard let centerViewController = centerViewController, 
              let notebook = centerViewController.notebook else {
            return
        }
        addNewNoteButton.isEnabled = false
        let addController = AddNoteViewController(notebook: notebook, dismissHandler: {
            centerViewController.updateNotes()
            self.addNewNoteButton.isEnabled = true
        })
        addController.moveTo(self)
    }
    
    @IBAction private func presentMoreActions() {
        guard let pageViewController = centerViewController,
              let viewController = pageViewController.viewControllers?.first as? NotesViewController,
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
                            if !pageViewController.removePresentingNote(note: note) {
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
        alertControlller.modalPresentationStyle = .popover
        alertControlller.popoverPresentationController?.barButtonItem = moreActionsButton
        self.present(alertControlller, animated: true, completion: nil)
    }

    ///This method checks if the notebook index is already appearing on screen or not. If it isn't appearing on screen, instaciates NotebookIndexViewController and peform an animation to show it. If it is appearing on screen, peform an animation to hide it.
    @IBAction private func presentNotebookIndex() {
        
        if let rightViewController = rightViewController {
            hideIndex(rightViewController)
        
        } else if let notebook = centerViewController?.notebook {
            showIndex(for: notebook)
        
        } else {
            // Present error alert
            let alertController = UIAlertController(
                title: "Error presenting Notebook Index".localized(),
                message: "The app could not present the Notebook Index".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The app could not load the NotebookIndexViewController".localized())
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
