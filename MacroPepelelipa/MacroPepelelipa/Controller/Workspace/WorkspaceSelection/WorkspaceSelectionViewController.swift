//
//  WorkspaceSelectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import StoreKit
import MarkdownText

internal class WorkspaceSelectionViewController: ViewController, 
                                                 UISearchResultsUpdating,
                                                 UISearchBarDelegate,
                                                 EntityObserver {

    // MARK: - Variables and Constants
    internal var overlayState = true
    
    internal weak var filterObserver: SearchBarObserver?
    
    private var compactRegularConstraints: [NSLayoutConstraint] = []
    private var regularCompactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var filterCategory: SearchResultEnum = .all
    private lazy var searchResultController = SearchResultViewController(owner: self)
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private lazy var searchController: CustomUISearchController = {
        let searchController = CustomUISearchController(searchResultsController: searchResultController, owner: self, placeHolder: "Search".localized())
        searchController.searchBar.delegate = self
        return searchController
    }()
    
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
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())

        collectionView.entityShouldBeDeleted = { (workspace) in
            if let workspace = workspace as? WorkspaceEntity,
               let cells = collectionView.visibleCells as? [WorkspaceCollectionViewCell],
               let cell = cells.first(where: { $0.workspace === workspace }) {
                self.deleteCell(cell: cell)
            }
        }
        
        return collectionView
    }()
    
    private lazy var collectionDelegate = WorkspacesCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let workspace = selectedCell.workspace else {
            let title = "Could not open this workspace".localized() 
            let message = "The workspace cell did not have a workspace".localized()
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            return
        }
        
        if !self.collectionView.isEditing {
            let notebooksSelectionView = NotebooksSelectionViewController(workspace: workspace)
            self.navigationController?.pushViewController(notebooksSelectionView, animated: true)
        } else if workspace.isEnabled {
            self.editWorkspace(workspace)
        }
    }
    
    private lazy var collectionDataSource = WorkspacesCollectionViewDataSource(viewController: self, collectionView: { self.collectionView })

    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        item.isAccessibilityElement = true
        item.accessibilityHint = "Add workspace hint".localized()
        item.accessibilityLabel = "Add workspace label".localized()
        return item
    }()
    
    private lazy var btnAddLooseNote: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addLooseNote))
        return item
    }()

    private lazy var onboardingButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .info, target: self, action: #selector(openOnboarding))
        item.isAccessibilityElement = true
        item.accessibilityLabel = "Onboarding label".localized()
        item.accessibilityHint = "Onboarding hint".localized()
        
        return item
    }()
    
    private lazy var emptyScreenView: EmptyScreenView = {
        let view = EmptyScreenView(
            frame: .zero,
            descriptionText: "No workspace".localized(),
            imageName: "Default-workspace",
            buttonTitle: "Create workspace".localized()) {
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
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCommand.title = "New workspace".localized()
        newCommand.discoverabilityTitle = "New workspace".localized()
        
        findCommand.title = "Find".localized()
        findCommand.discoverabilityTitle = "Find".localized()
        
        view.backgroundColor = .rootColor
        navigationItem.rightBarButtonItems = [btnAdd, btnAddLooseNote, onboardingButton]

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Workspaces".localized()
        view.addSubview(collectionView)
        view.addSubview(emptyScreenView)
        navigationItem.searchController = searchController
        
        setConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.defaultHeader.toStyle(.h1),
            .foregroundColor: UIColor.titleColor ?? .black
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.defaultHeader.toStyle(.h3),
            .foregroundColor: UIColor.titleColor ?? .black
        ]

        self.definesPresentationContext = true
        
        createOnboarding()
        
        DataManager.shared().addCreationObserver(self, type: .workspace)
        setEditButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIMenuSystem.main.setNeedsRebuild()
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
        collectionDelegate.frame = view.frame
        collectionView.collectionViewLayout.invalidateLayout()
        self.enableLooseNote(collectionDataSource.hasNotebooks())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DataManager.shared().removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionDelegate.frame = CGRect(origin: view.frame.origin, size: size)
        collectionView.collectionViewLayout.invalidateLayout()
        invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            updateConstraintsForIpad()
        }
        collectionDelegate.frame = view.frame
        
        if overlayState == true {
            showDemoLaunchOverlay()
            overlayState=false
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
    
    // MARK: - Demo Launch
    
    private func createOnboarding() {
        do {
            let workspace = try DataManager.shared().createWorkspace(named: "Your first workspace".localized())
            
            let introductionNotebook = try DataManager.shared().createNotebook(in: workspace, named: "Introduction", colorName: "nb19")
            let introductionNote = try DataManager.shared().createNote(in: introductionNotebook)
            introductionNote.title = TutorialNotesHelper.buildIntroductionTitle()
            introductionNote.text = TutorialNotesHelper.buildIntroductionText()
            
            let customizeNotebook = try DataManager.shared().createNotebook(in: workspace, named: "Customize", colorName: "nb5")
            let customizeNote = try DataManager.shared().createNote(in: customizeNotebook)
            customizeNote.title = TutorialNotesHelper.buildCustomizeTitle()
            customizeNote.text = TutorialNotesHelper.buildCustomizeText()
            
            let indexNotebook = try DataManager.shared().createNotebook(in: workspace, named: "Index", colorName: "nb6")
            let indexNote = try DataManager.shared().createNote(in: indexNotebook)
            indexNote.title = TutorialNotesHelper.buildIndexTitle()
            indexNote.text = TutorialNotesHelper.buildIndexText()
            
            let examplesNotebook = try DataManager.shared().createNotebook(in: workspace, named: "Examples", colorName: "nb11")
            let examplesNote = try DataManager.shared().createNote(in: examplesNotebook)
            examplesNote.title = TutorialNotesHelper.buildExamplesTitle()
            examplesNote.text = TutorialNotesHelper.buildExamplesText()
                        
        } catch {
            // Precisamos lidar com isso ainda
            fatalError()
        }
    }
    
    private func showDemoLaunchOverlay() {
        let destination = DemoLaunchViewController(nibName: "DemoLaunchViewController", bundle: nil)
        destination.isModalInPresentation = true
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overFullScreen
        
        self.present(destination, animated: false, completion: nil)
    }
    
    // MARK: - UISearchResultsUpdating Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterObserver?.filterObjects(text, filterCategory: filterCategory)
        }
        let value = searchController.isActive && !isSearchBarEmpty
        searchController.showsSearchResultsController = true
        filterObserver?.isFiltering(value)
        searchResultController.collectionView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate Functions
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {
            return
        }
        self.filterCategory = SearchResultEnum(rawValue: scopeButtonTitles[selectedScope]) ?? .all
        
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterObserver?.filterObjects(text, filterCategory: filterCategory)
            self.collectionView.reloadData()
        }
    }
    
    private func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        for visibleCell in collectionView.visibleCells {
            if let cell = visibleCell as? WorkspaceCollectionViewCell {
                cell.updateLayout()
            }
        }
    }

    ///This private method sets the constraints for different size classes and devices.
    private func setConstraints() {
        sharedConstraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
                emptyScreenView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
                emptyScreenView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
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
    
    /// This method presents or hide the Edit button item at the navigation bar
    private func setEditButtonItem() {
        
        if !collectionDataSource.isEmpty {
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.leftBarButtonItem?.accessibilityHint = "Edit workspaces hint".localized()
            navigationItem.leftBarButtonItem?.accessibilityLabel = "Edit workspaces label".localized()
            navigationItem.leftBarButtonItem?.accessibilityValue = "Editing disabled".localized()
        } else {
            navigationItem.leftBarButtonItem = nil
            setEditing(false, animated: true)
        }
    }

    private func editWorkspace(_ workspace: WorkspaceEntity) {
        let workspaceEditingController = AddWorkspaceViewController()

        workspaceEditingController.isModalInPresentation = true
        workspaceEditingController.modalTransitionStyle = .crossDissolve
        workspaceEditingController.modalPresentationStyle = .overFullScreen

        workspaceEditingController.workspace = workspace
        self.present(workspaceEditingController, animated: true)
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
    
    /// This method updates the view's constraints for an iPad based on the device orientation.
    private func updateConstraintsForIpad() {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if isLandscape {
            
            if view.frame.width+5 == UIScreen.main.bounds.width/2 {
                // Multitasking half screen
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
                activate.append(contentsOf: compactRegularConstraints)
                
            } else if view.frame.width < UIScreen.main.bounds.width/2 {
                // Multitasking less than half screen
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
                activate.append(contentsOf: compactRegularConstraints)
                
            } else if view.frame.width == UIScreen.main.bounds.width {
                // Full screen
                deactivate.append(contentsOf: compactRegularConstraints[0].isActive ? compactRegularConstraints : [])
                deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
                activate.append(contentsOf: regularConstraints)
                
            } else {
                // Multitasking more than half screen
                deactivate.append(contentsOf: compactRegularConstraints[0].isActive ? compactRegularConstraints : [])
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                activate.append(contentsOf: regularCompactConstraints)
            }
            
        } else {
            
            if view.frame.width < UIScreen.main.bounds.width/2 {
                // Multitasking less than half screen
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
                activate.append(contentsOf: compactRegularConstraints)
            
            } else if view.frame.width == UIScreen.main.bounds.width {
                // Full screen
                deactivate.append(contentsOf: compactRegularConstraints[0].isActive ? compactRegularConstraints : [])
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                activate.append(contentsOf: regularCompactConstraints)
            } else {
                // Multitasking more than half screen
                deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
                deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
                activate.append(contentsOf: compactRegularConstraints)
            }
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
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
    
    /**
     This method enables or disenables the button to add a Loose Note.
     - Parameter shouldBeEnabled: A boolean indicating if the button should or not be enabled. It is true by default.
     */
    internal func enableLooseNote(_ shouldBeEnabled: Bool = true) {
        self.btnAddLooseNote.isEnabled = shouldBeEnabled
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
    
    /**
     This method opens the onboarding screen once the user clicks on the information button.
     */
    @IBAction func openOnboarding() {
        let onboardingViewController = OnboardingPageViewController()
        self.present(onboardingViewController, animated: true, completion: nil)
    }
    
    /// Makes the search controller first responder
    @IBAction func startSearch() {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func btnAddTap() {
        btnAdd.isEnabled = false
        
        let destination = AddWorkspaceViewController()
        destination.isModalInPresentation = true
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overFullScreen
        
        self.present(destination, animated: true) { 
            self.btnAdd.isEnabled = true
        }
    }
    
    @IBAction func addLooseNote() {
        var looseNote: NoteEntity?
        
        do {
            looseNote = try DataManager.shared().createLooseNote()
        } catch {
            let title = "Failed to create Loose Note".localized()
            let message = "The database could not create the Loose Note".localized()
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
        
        if let note = looseNote {
            #if !targetEnvironment(macCatalyst)
            let looseNoteViewController = LooseNoteViewController(
                note: note,
                notebook: collectionDataSource.getLastNotebook(),
                workspaces: { self.collectionDataSource.workspaces }
            )
            #else
            let looseNoteViewController = MacLooseNoteViewController(
                note: note,
                notebook: collectionDataSource.getLastNotebook(),
                workspaces: { self.collectionDataSource.workspaces }
            )
            #endif
            
            let destination = UINavigationController(rootViewController: looseNoteViewController)
            destination.isModalInPresentation = true
            destination.modalTransitionStyle = .crossDissolve
            destination.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(destination, animated: true, completion: nil)
        }
    }
    
    /**
     This method handles the long press on a workspace, asking the user to delete it or not.
     - Parameter gesture: The UILongPressGestureRecognizer containing the gesture.
     */
    @IBAction func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let cell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell else {
            return
        }

        deleteCell(cell: cell)
    }

    private func deleteCell(cell: WorkspaceCollectionViewCell) {
        guard let workspace = cell.workspace else {
            return
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "Delete Workspace confirmation".localized(),
                                                          message: "Warning".localized(),
                                                          preferredStyle: .alert).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { _ in
                                                            do {
                                                                try DataManager.shared().deleteWorkspace(workspace)
                                                            } catch {
                                                                let title = "Could not delete this workspace".localized()
                                                                let message = "An error occurred while deleting this instance on the database".localized()
                                                                
                                                                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                                                            }
                                                          })
            self?.present(deleteAlertController, animated: true, completion: nil)
        })

        if workspace.isEnabled {
            let editAction = UIAlertAction(title: "Edit Workspace".localized(), style: .default, handler: { _ in
                self.setEditing(true, animated: true)
                self.editWorkspace(workspace)
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
    
    override func commandF() {
        startSearch()
    }
}
