//
//  MacLooseNoteViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 23/03/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

#if targetEnvironment(macCatalyst)
import AppKit
import UIKit
import Database

class MacLooseNoteViewController: MacNotesViewController, NoteAssignerObserver {
    
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
        
        self.customView.notesToolbar.customizeButtons(with: false)
        
        self.setDeleteNoteButton {
            let alertControlller = UIAlertController(
                title: "Delete Note confirmation".localized(),
                message: "Warning".localized(),
                preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .note) { _ in
                let deleteAlertController = UIAlertController(
                    title: "Delete note confirmation".localized(),
                    message: "Warning".localized(),
                    preferredStyle: .alert).makeDeleteConfirmation(dataType: .note) { _ in
                        self.dismiss(animated: true, completion: nil)
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
        
        self.shareFileTriggered = { (identifier) in
            switch identifier {
            case .init("note"):
                self.exportNote()
            case .init("notebook"):
                self.exportNotebook()
            default:
                break
            }
        }
    }

    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addNoteBarButton]
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
}
#endif