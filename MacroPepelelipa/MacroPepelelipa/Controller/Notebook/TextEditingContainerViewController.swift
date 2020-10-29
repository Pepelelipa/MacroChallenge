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
    
    private var movement: CGFloat?
    private var isShowingIndex: Bool = false
    private var centerViewController: NotesPageViewController?
    private weak var rightViewController: NotebookIndexViewController?
    
    internal var widthConstraint: NSLayoutConstraint?
    
    private lazy var notebookIndexButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .index, 
                                   target: self, 
                                   action: #selector(presentNotebookIndex))
        return item
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .done,
                                   target: self,
                                   action: #selector(closeKeyboard))
        
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
    
    private lazy var constraints: [NSLayoutConstraint] = {
        if let centerViewController = centerViewController {
            centerViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            var constraints: [NSLayoutConstraint] = [
                centerViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                centerViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                centerViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                centerViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
            return constraints
        }
        return []
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

        if (try? notesViewController?.note?.getNotebook().getWorkspace().isEnabled) ?? false {
            navigationItem.rightBarButtonItems = [notebookIndexButton]
        } else {
            navigationItem.rightBarButtonItems = [notebookIndexButton]
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = markupNavigationView
        navigationItem.titleView?.backgroundColor = .clear
        view.backgroundColor = .rootColor
        
        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        #endif
        
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
            rightView.frame.origin.x -= self.view.frame.width * 0.4
        }

        self.rightViewController = rightViewController
        isShowingIndex = true
    }
    
    /**
     This method peforms an animation to hide the NotebookIndexViewController.
     - Parameter rightViewController: the presenting NotebookIndexViewController.
     */
    private func hideIndex(_ rightViewController: NotebookIndexViewController) {
        UIView.animate(withDuration: 0.5) {
            rightViewController.view.frame.origin.x += self.view.frame.width * 0.4
        } completion: { _ in
            rightViewController.willMove(toParent: nil)
            rightViewController.removeFromParent()
            rightViewController.view.removeFromSuperview()
            rightViewController.didMove(toParent: nil)
        }

        self.rightViewController = nil
        isShowingIndex = false
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
    
    // MARK: - IndexObserver functions
    
    internal func didChangeIndex(to note: NoteEntity) {
        if let rightViewController = rightViewController,
           let centerViewController = centerViewController {
            
            centerViewController.setNotesViewControllers(for: NotesViewController(note: note))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
                self.hideIndex(rightViewController)
            }
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
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.present(picker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default) { (action) in
            noteController.showImagePickerController(sourceType: .camera)
        }
        
        let alertController = UIAlertController(
            title: "Error presenting notebook creation".localized(),
            message: "The app could not present a color".localized(),
            preferredStyle: .alert)
            .makeErrorMessage(with: "A color cell could not be loaded in the creation of a notebook".localized())

        alertController.createMultipleActionsAlert(on: self, title: "Choose your image", message: "Tip: you can transcript text from an image.", action: [photoLibraryAction, cameraAction])
        
        #endif
    }

    internal func changeTextViewInput(isCustom: Bool) {
        if let noteController = centerViewController?.viewControllers?.first as? NotesViewController {
            noteController.changeTextViewInput(isCustom: isCustom)
        }
    }
    
    // MARK: - IBActions functions
    
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
    
    // This method is called when the UIBarButton for the done button is pressed and it closes the keyboard
    @IBAction private func closeKeyboard() {
        self.view.endEditing(true)
    }
}
