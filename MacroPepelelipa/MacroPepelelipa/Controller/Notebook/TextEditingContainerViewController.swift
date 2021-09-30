//
//  TextEditingContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PhotosUI

internal class TextEditingContainerViewController: ViewController,
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
        
        item.accessibilityLabel = "Index button label".localized()
        item.accessibilityHint = "Index button hint".localized()
        
        return item
    }()
    
    private lazy var presentTipButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(presentTip))

        return item
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .done,
                                   target: self,
                                   action: #selector(closeKeyboard))
        
        item.accessibilityLabel = "Done".localized()
        item.accessibilityHint = "End editing hint".localized()
        
        return item
    }()
    
    private lazy var notesViewController = centerViewController?.viewControllers?.first as? NotesViewController
    
    internal lazy var markupConfig: MarkdownBarConfiguration = {
        guard let textView = notesViewController?.customView.textView else {
            fatalError("Controller not found")
        }
        let mrkConf = MarkdownBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    private lazy var markupNavigationView: MarkdownNavigationView = {
        let mrkView = MarkdownNavigationView(frame: .zero, configurations: markupConfig)
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
    
    internal required convenience init?(coder: NSCoder) {
        guard let centerViewController = coder.decodeObject(forKey: "centerViewController") as? NotesPageViewController else {
            return nil
        }
        self.init(centerViewController: centerViewController)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCommand.title = "New note".localized()
        newCommand.discoverabilityTitle = "New note".localized()
        
        deleteCommand.title = "Delete note".localized()
        deleteCommand.discoverabilityTitle = "Delete note".localized()
        
        if let centerViewController = self.centerViewController {
            showCenterViewController(centerViewController)
        } else {
            navigationController?.popViewController(animated: true)
        }

        if (try? notesViewController?.note?.getNotebook().getWorkspace().isEnabled) ?? false {
            navigationItem.rightBarButtonItems = [notebookIndexButton, presentTipButton]
        } else {
            navigationItem.rightBarButtonItems = [notebookIndexButton, presentTipButton]
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = markupNavigationView
        navigationItem.titleView?.backgroundColor = .backgroundColor
        navigationController?.navigationBar.barTintColor = .backgroundColor
        view.backgroundColor = .rootColor
        
        #if targetEnvironment(macCatalyst)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.backgroundColor
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
        guard let textView = notesViewController?.customView.textView else {
            return
        }

        let markupContainerViewController = MarkupContainerViewController(owner: textView,
                                                                          viewController: notesViewController,
                                                                          size: .init(width: 400, height: 110))

        markupContainerViewController.modalPresentationStyle = .popover
        markupContainerViewController.popoverPresentationController?.sourceView = markupNavigationView.barButtonItems[.format]
        
        if let textView = notesViewController?.customView.textView {
            markupContainerViewController.popoverPresentationController?.passthroughViews = [textView]
        }

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
            
            #if targetEnvironment(macCatalyst)
            centerViewController.setNotesViewControllers(for: MacNotesViewController(note: note))
            #else
            centerViewController.setNotesViewControllers(for: NotesViewController(note: note))
            #endif
            
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

    internal func changeTextViewInput(isCustom: Bool) {
        if let noteController = centerViewController?.viewControllers?.first as? NotesViewController {
            noteController.changeTextViewInput(isCustom: isCustom)
        }
    }
    
    /// This method presentes the photo picker for iOS and iPadOS
    internal func presentPhotoPicker() {
        (centerViewController?.viewControllers?.first as? NotesViewController)?.presentPhotoPicker()
    }
    
    /// This method presentes the camera picker for iOS and iPadOS
    internal func presentCameraPicker() {
        (centerViewController?.viewControllers?.first as? NotesViewController)?.presentCameraPicker()
    }
    
    /// This method presentes the file handler for macOS
    internal func importImage() {
        #if targetEnvironment(macCatalyst)
        (centerViewController?.viewControllers?.first as? NotesViewController)?.importImage()
        #endif
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func createNote() {
        self.centerViewController?.createNote()
    }
    
    @IBAction private func deleteNote() {
        self.centerViewController?.deleteNote()
    }

    ///This method checks if the notebook index is already appearing on screen or not. If it isn't appearing on screen, instaciates NotebookIndexViewController and peform an animation to show it. If it is appearing on screen, peform an animation to hide it.
    @IBAction private func presentNotebookIndex() {
        
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if view.frame.width == UIScreen.main.bounds.width ||
            (view.frame.width > UIScreen.main.bounds.width/2 && isLandscape) {
            if let rightViewController = rightViewController {
                hideIndex(rightViewController)
            
            } else if let notebook = centerViewController?.notebook {
                showIndex(for: notebook)
            
            } else {
                let title = "Error presenting Notebook Index".localized()
                let message = "The app could not load the NotebookIndexViewController".localized()
                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            }
        } else {
            if let presentNotebook = centerViewController?.notebook,
               let index = centerViewController?.index,
               let presentNote = centerViewController?.notes[index] {
                
                let notebookIndexViewController = NotebookIndexViewController(notebook: presentNotebook, 
                                                                              note: presentNote)
                notebookIndexViewController.observer = self
                self.present(notebookIndexViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func presentTip() {
        let tipNaviationController = UINavigationController(rootViewController: TipViewController())
        self.present(tipNaviationController, animated: true, completion: nil)
    }
    
    // This method is called when the UIBarButton for the done button is pressed and it closes the keyboard
    @IBAction private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard shortcut handling
    
    override func commandDelete() {
       deleteNote()
    }
    
    override func commandN() {
        createNote()
    }
}
