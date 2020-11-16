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

internal class WorkspaceSelectionViewController: UIViewController, 
                                                 UISearchResultsUpdating,
                                                 UISearchBarDelegate {

    // MARK: - Variables and Constants
    
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
        collectionView.allowsSelectionDuringEditing = true
        collectionView.allowsMultipleSelection = false
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
            let alertController = UIAlertController(
                title: "Could not open this workspace".localized(),
                message: "The app could not load this workspace".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The workspace cell did not have a workspace".localized())
            
            self.present(alertController, animated: true, completion: nil)
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
        view.backgroundColor = .rootColor
        navigationItem.rightBarButtonItem = btnAdd
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

        let time = UserDefaults.standard.integer(forKey: "numberOfTimes")
        if time == 8 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                #if !DEBUG && !targetEnvironment(macCatalyst)
                SKStoreReviewController.requestReview(in: scene)
                #endif
            }
        } else {
            UserDefaults.standard.setValue(time + 1, forKey: "numberOfTimes")
        }
        self.definesPresentationContext = true
        if !collectionDataSource.isEmpty {
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
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
                cell.invalidateLayout()
            }
        }
    }

    /**
     This private method sets the constraints for different size classes and devices.
     */
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
                                                          preferredStyle: .alert).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { [weak self] _ in
                                                            do {
                                                                try DataManager.shared().deleteWorkspace(workspace)
                                                            } catch {
                                                                let alertController = UIAlertController(
                                                                    title: "Could not delete this workspace".localized(),
                                                                    message: "The app could not delete the workspace".localized() + workspace.name,
                                                                    preferredStyle: .alert)
                                                                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                self?.present(alertController, animated: true, completion: nil)
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

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = cell
            alertController.popoverPresentationController?.sourceRect = cell.frame
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
