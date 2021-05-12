//
//  LooseNoteViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
import UIKit
import Database

internal class LooseNoteViewController: NotesViewController, NoteAssignerObserver {
    
    // MARK: - Variables and Constants
    private var workspaces: () -> [WorkspaceEntity]
    
    private lazy var addNoteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Finish".localized(),
            style: .plain,
            target: self,
            action: #selector(addToNotebook)
        )
    }()
        
    private lazy var doneBarButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .done,
                                   target: self,
                                   action: #selector(closeKeyboard))
        item.tintColor = UIColor.actionColor
        return item
    }()
    
    internal lazy var markupConfig: MarkdownBarConfiguration = {
        let mrkConf = MarkdownBarConfiguration(owner: self.customView.textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    private lazy var markupNavigationView: MarkdownNavigationView = {
        let mrkView = MarkdownNavigationView(frame: .zero, configurations: markupConfig)
        return mrkView
    }()
    
    // MARK: - Initializers
    
    internal init(note: NoteEntity, notebook: NotebookEntity? = nil, workspaces: @escaping () -> [WorkspaceEntity]) {
        self.workspaces = workspaces
        super.init(looseNote: note, notebook: notebook)
    }

    internal required convenience init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity,
              let workspaces = coder.decodeObject(forKey: "workspaces") as? () -> [WorkspaceEntity]
              else {
            return nil
        }
        self.init(note: note, notebook: coder.decodeObject(forKey: "notebook") as? NotebookEntity, workspaces: workspaces)
    }

    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addNoteBarButton]
        self.customView.textView.allowsEditingTextAttributes = true
        self.customView.notesToolbar.customizeButtons(with: false)
        
        self.setDeleteNoteButton {
            let alertControlller = UIAlertController(
                title: "Delete Note confirmation".localized(),
                message: "Warning".localized(),
                preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .note) { _ in
                let deleteAlertController = UIAlertController(
                    title: "Delete Note confirmation".localized(),
                    message: "Warning".localized(),
                    preferredStyle: .alert).makeDeleteConfirmation(dataType: .note) { _ in
                        if let noteEntity = self.note {
                            do {
                                try DataManager.shared().deleteNote(noteEntity)
                                self.dismiss(animated: true, completion: nil)
                            } catch {
                                let title = "Could not delete this note".localized()
                                let message = "An error occurred while deleting this instance on the database".localized()
                                
                                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                            }
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                }
                self.present(deleteAlertController, animated: true, completion: nil)
            }
            alertControlller.popoverPresentationController?.barButtonItem = self.customView.notesToolbar.deleteNoteButton
            self.present(alertControlller, animated: true, completion: nil)
        }
        
        self.setAddImageButton { (identifier) in
            switch identifier {
            case .init("camera"):
                self.presentCameraPicker()
            case .init("library"):
                self.presentPhotoPicker()
            default:
                break
            }
        }
        
        self.setShareButton { (sender) in
            guard let userNotebook = self.notebook else {
                return
            }
            let objectsToShare: [Any] = [userNotebook.createFullDocument()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.barButtonItem = sender
            self.present(activityVC, animated: true, completion: nil)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.titleView = markupNavigationView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.actionColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
   
    // MARK: - NoteAssignerObserver Method
    func dismissLooseNoteViewController() {
        self.navigationController?.popViewController(animated: true)
    }
        
    // MARK: - IBActions functions
    
    @IBAction private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func addToNotebook() {
        let destination = NoteAssignerViewController(note: note, lastNotebook: notebook, workspaces: workspaces)
        destination.observer = self
        noteContentHandler.saveNote(
            note: &note,
            textField: customView.textField,
            textView: customView.textView,
            textBoxes: textBoxes,
            imageBoxes: imageBoxes
        )
        self.navigationController?.pushViewController(destination, animated: true)
    }

// MARK: - MarkupToolBarObserver
    
    ///This method opens the pop over when the button is pressed
    @objc internal override func openPopOver() {
        let markupContainerViewController = MarkupContainerViewController(owner: self.customView.textView,
                                                                          viewController: self,
                                                                          size: .init(width: 400, height: 110))

        markupContainerViewController.modalPresentationStyle = .popover
        markupContainerViewController.popoverPresentationController?.sourceView = markupNavigationView.barButtonItems[.format]
        markupContainerViewController.popoverPresentationController?.passthroughViews = [self.customView.textView]
        present(markupContainerViewController, animated: true)
    }
}
#endif
