//
//  NotebooksCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksSelectionViewController: ViewController, EntityObserver {
    
    // MARK: - Variables and Constants
    
    private var collectionDataSource: NotebooksCollectionViewDataSource?
    
    internal private(set) weak var workspace: WorkspaceEntity?

    private lazy var collectionView: EditableCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let collectionView = EditableCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelectionDuringEditing = true
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource
        
        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID())

        collectionView.entityShouldBeDeleted = { (notebook) in
            if let notebook = notebook as? NotebookEntity,
               let cells = collectionView.visibleCells as? [NotebookCollectionViewCell],
               let cell = cells.first(where: { $0.notebook === notebook }) {
                self.deleteCell(cell: cell)
            }
        }
        
        return collectionView
    }()

    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        item.isAccessibilityElement = true
        item.accessibilityHint = "Add notebook hint".localized()
        item.accessibilityLabel = "Add notebook label".localized()
        return item
    }()
    
    private lazy var emptyScreenView: EmptyScreenView = {
        let view = EmptyScreenView(
            frame: .zero,
            descriptionText: "No notebook".localized(),
            imageName: "Default-notebook",
            buttonTitle: "Create notebook".localized()) {
            self.btnAddTap()
        }
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var collectionDelegate = NotebooksCollectionViewDelegate { [unowned self] (selectedCell) in
        if let notebook = selectedCell.notebook {
            if !self.collectionView.isEditing {
                let note: NoteEntity
                if let lastNote = notebook.notes.last {
                    note = lastNote
                } else {
                    do {
                        note = try DataManager.shared().createNote(in: notebook)
                    } catch {
                        let title = "Could not open this notebook".localized()
                        let message = "The app could not load this notebook".localized()
                        ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                    }
                }

                self.presentDestination(for: UIDevice.current.userInterfaceIdiom, notebook: notebook)
            } else {
                self.editNotebook(notebook)
            }
        } else {
            let title = "Could not open this notebook".localized()
            let message = "The app could not load this notebook".localized()
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
    }
    
    // MARK: - Initializers
    
    internal init(workspace: WorkspaceEntity) {
        super.init(nibName: nil, bundle: nil)
        self.workspace = workspace
        self.collectionDataSource = NotebooksCollectionViewDataSource(notebooks: workspace.notebooks, viewController: self, collectionView: { self.collectionView })
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let workspace = coder.decodeObject(forKey: "workspace") as? WorkspaceEntity else {
            return nil
        }
        self.init(workspace: workspace)
    }

    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()

        newCommand.title = "New notebook".localized()
        newCommand.discoverabilityTitle = "New notebook".localized()
        
        if workspace?.isEnabled ?? false {
            navigationItem.rightBarButtonItem = btnAdd
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
        navigationItem.title = workspace?.name
        navigationItem.backBarButtonItem?.setTitleTextAttributes([.font: UIFont.defaultHeader.toStyle(.h3)], for: .application)
        
        view.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        view.addSubview(emptyScreenView)
        
        setConstraints()
        
        DataManager.shared().addCreationObserver(self, type: .notebook)
        setEditButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIMenuSystem.main.setNeedsRebuild()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionDelegate.frame = view.frame
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DataManager.shared().removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionDelegate.frame = CGRect(origin: view.frame.origin, size: size)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.setEditing(editing)
        
        if editing {
            navigationItem.leftBarButtonItem?.accessibilityValue = "Editing enabled".localized()
        } else {
            navigationItem.leftBarButtonItem?.accessibilityValue = "Editing disabled".localized()
        }
    }
    
    // MARK: - Functions
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyScreenView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyScreenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            emptyScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        emptyScreenView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                                 constant: navigationController?.navigationBar.frame.height ?? 0)
        ])
    }
    
    /// This method presents or hide the Edit button item at the navigation bar
    private func setEditButtonItem() {
        
        if !(collectionDataSource?.isEmpty() ?? true) && (workspace?.isEnabled ?? false) {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = self.editButtonItem
            navigationItem.leftBarButtonItem?.accessibilityHint = "Edit notebooks hint".localized()
            navigationItem.leftBarButtonItem?.accessibilityLabel = "Edit notebooks label".localized()
            navigationItem.leftBarButtonItem?.accessibilityValue = "Editing disabled".localized()
        } else {
            navigationItem.leftItemsSupplementBackButton = false
            navigationItem.leftBarButtonItem = nil
            setEditing(false, animated: true)
        }
    }
    
    private func presentDestination(for device: UIUserInterfaceIdiom, notebook: NotebookEntity) {
        
        let notesPageViewController = NotesPageViewController(notes: notebook.notes)
        
        if device == .phone {
            self.navigationController?.pushViewController(notesPageViewController, animated: true)
        
        } else {
            let destination = TextEditingContainerViewController(centerViewController: notesPageViewController)
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    /**
     This method displays or hides the placeholder view when called.
     - Parameter sholdBeHidden: A boolean indicating if the view shold or not be hidden. It is false by default.
     */
    internal func switchEmptyScreenView(shouldBeHidden: Bool = false) {
        let alpha: CGFloat = shouldBeHidden ? 0 : 1
        emptyScreenView.isHidden = shouldBeHidden
        
        UIView.animate(withDuration: 0.5, animations: {
            self.emptyScreenView.alpha = alpha
        }, completion: { _ in
            if alpha == 0 {
                self.emptyScreenView.isHidden = true
            }
        })
    }
    
    // MARK: - EntityObserver functions
    
    internal func entityWasCreated(_ value: ObservableEntity) {
        setEditButtonItem()
    }
    
    internal func entityShouldDelete(_ value: ObservableEntity) {
        setEditButtonItem()
    }

    internal func getEntityWithID(_ value: String) -> ObservableEntity? {
        setEditButtonItem()
        return nil
    }
    
    // MARK: - IBActions functions

    @IBAction private func btnAddTap() {
        btnAdd.isEnabled = false
        navigationItem.hidesBackButton = true
        AppUtility.setOrientation(.portrait, andRotateTo: .portrait)
        
        let destination = AddNotebookViewController(workspace: workspace)
        
        destination.isModalInPresentation = true
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overFullScreen
        
        present(destination, animated: true) { 
            self.btnAdd.isEnabled = true
            self.navigationItem.hidesBackButton = false
            AppUtility.setOrientation(.all)
        }
    }
    
    /**
     This method handles the long press on a notebook, asking the user to delete it or not.
     - Parameter gesture: The UILongPressGestureRecognizer containing the gesture.
     */
    @IBAction func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let cell = collectionView.cellForItem(at: indexPath) as? NotebookCollectionViewCell else {
            return
        }
        deleteCell(cell: cell)
    }

    private func editNotebook(_ notebook: NotebookEntity) {
        let notebookEditingController = AddNotebookViewController(workspace: workspace)

        notebookEditingController.isModalInPresentation = true
        notebookEditingController.modalTransitionStyle = .crossDissolve
        notebookEditingController.modalPresentationStyle = .overFullScreen

        notebookEditingController.notebook = notebook
        self.present(notebookEditingController, animated: true)
    }

    private func deleteCell(cell: NotebookCollectionViewCell) {
        
        guard let notebook = cell.notebook else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .notebook, deletionHandler: { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "Delete Notebook confirmation".localized(),
                                                          message: "Warning".localized(),
                                                          preferredStyle: .alert).makeDeleteConfirmation(dataType: .notebook, deletionHandler: { _ in
                                                            do {
                                                                try DataManager.shared().deleteNotebook(notebook)
                                                            } catch {
                                                                let title = "Could not delete this notebook".localized()
                                                                let message = "An error occurred while deleting this instance on the database".localized()
                                                                
                                                                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                                                            }
                                                          })
            self?.present(deleteAlertController, animated: true, completion: nil)
        })

        if workspace?.isEnabled ?? false {
            let editAction = UIAlertAction(title: "Edit Notebook".localized(), style: .default, handler: { _ in
                self.setEditing(true, animated: true)
                self.editNotebook(notebook)
            })
            alertController.addAction(editAction)
        }

        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            alertController.popoverPresentationController?.sourceView = cell
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard shortcut handling
    
    override func commandN() {
        btnAddTap()
    }
}
