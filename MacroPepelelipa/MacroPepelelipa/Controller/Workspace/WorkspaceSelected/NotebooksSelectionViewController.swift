//
//  NotebooksCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksSelectionViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    internal static let newNotebookCommand: UIKeyCommand = {
        let command = UIKeyCommand(title: "New notebook".localized(),
                                   image: nil,
                                   action: #selector(btnAddTap),
                                   input: "N",
                                   modifierFlags: .command,
                                   propertyList: nil)
        command.discoverabilityTitle = "New notebook".localized()
        return command
    }()
    
    private var collectionDataSource: NotebooksCollectionViewDataSource?
    private var compactRegularConstraints: [NSLayoutConstraint] = []
    private var regularCompactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            view.isLandscape = UIDevice.current.orientation.isActuallyLandscape
        }
        
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
                        self.presentErrorAlert()
                    }
                }

                self.presentDestination(for: UIDevice.current.userInterfaceIdiom, notebook: notebook)
            } else {
                self.editNotebook(notebook)
            }
        } else {
            self.presentErrorAlert()
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

        addKeyCommand(NotebooksSelectionViewController.newNotebookCommand)
        
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
        NSLayoutConstraint.activate(sharedConstraints)
        if UIDevice.current.userInterfaceIdiom != .pad && UIDevice.current.userInterfaceIdiom != .mac  {
            layoutTrait(traitCollection: UIScreen.main.traitCollection)
        }

        if !(collectionDataSource?.isEmpty() ?? true) && (workspace?.isEnabled ?? false) {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = self.editButtonItem
            navigationItem.leftBarButtonItem?.accessibilityHint = "Edit notebooks hint".localized()
            navigationItem.leftBarButtonItem?.accessibilityLabel = "Edit notebooks label".localized()
            navigationItem.leftBarButtonItem?.accessibilityValue = "Editing disabled".localized()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIMenuSystem.main.setNeedsRebuild()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac  {
            updateConstraintsForIpad()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            emptyScreenView.isLandscape = UIDevice.current.orientation.isActuallyLandscape
        }
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
        sharedConstraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyScreenView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyScreenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        compactRegularConstraints.append(contentsOf: [
            emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            regularCompactConstraints.append(contentsOf: [
                emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
            ])
        } else {
            regularCompactConstraints.append(contentsOf: [
                emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35),
                emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35)
            ])
        }
        
        regularConstraints.append(contentsOf: [
            emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25)
        ])
    }
    
    /**
     This method layouts the appropriate constraits based on the current trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            updateConstraintsForIphone(with: traitCollection)
        } else {
            updateConstraintsForIpad()
        }
    }
    
    /**
     This method updates the view's constraints for an iPhone based on a trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func updateConstraintsForIphone(with traitCollection: UITraitCollection) {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        if traitCollection.horizontalSizeClass == .compact {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
            activate.append(contentsOf: compactRegularConstraints)
        } else {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            deactivate.append(contentsOf: compactRegularConstraints[0].isActive ? compactRegularConstraints : [])
            activate.append(contentsOf: regularCompactConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
    
    /**
     This method updates the view's constraints for an iPad based on the device orientation.
     */
    private func updateConstraintsForIpad() {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        if orientation == .portrait || orientation == .portraitUpsideDown {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            activate.append(contentsOf: regularCompactConstraints)
        } else {
            deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
            activate.append(contentsOf: regularConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
    
    private func presentErrorAlert() {
        
         let alertController = UIAlertController(
            title: "Could not open this notebook".localized(),
            message: "The app could not load this notebook".localized(),
            preferredStyle: .alert)
            .makeErrorMessage(with: "The notebook collection view cell did not have a notebook".localized())
        
        self.present(alertController, animated: true, completion: nil)
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
                                                          preferredStyle: .alert).makeDeleteConfirmation(dataType: .notebook, deletionHandler: { [weak self] _ in
                                                            do {
                                                                try DataManager.shared().deleteNotebook(notebook)
                                                            } catch {
                                                                let alertController = UIAlertController(
                                                                    title: "Could not delete this notebook".localized(),
                                                                    message: "The app could not delete the notebook".localized() + notebook.name,
                                                                    preferredStyle: .alert)
                                                                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                self?.present(alertController, animated: true, completion: nil)
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

        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac  {
            alertController.popoverPresentationController?.sourceView = cell
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
