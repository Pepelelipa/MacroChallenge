//
//  WorkspaceSelectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspaceSelectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false

        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource

        collectionView.register(
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())

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

        let notebooksSelectionView = NotebooksSelectionViewController(workspace: workspace)

        self.navigationController?.pushViewController(notebooksSelectionView, animated: true)
    }
    private lazy var collectionDataSource = WorkspacesCollectionViewDataSource(viewController: self, collectionView: { self.collectionView })

    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        return item
    }()
    @IBAction func btnAddTap() {
        btnAdd.isEnabled = false
        let addController = AddWorkspaceViewController(dismissHandler: {
            self.btnAdd.isEnabled = true
        })
        addController.moveTo(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootColor
        navigationItem.rightBarButtonItem = btnAdd
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Workspaces".localized()
        view.addSubview(collectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.invalidateLayout()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateLayout()
    }

    private func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        for visibleCell in collectionView.visibleCells {
            if let cell = visibleCell as? WorkspaceCollectionViewCell {
                cell.invalidateLayout()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     This method handles the long press on a workspace, asking the user to delete it or not.
     
     - Parameter gesture: The UILongPressGestureRecognizer containing the gesture.
     */
    @IBAction func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let cell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell,
              let workspace = cell.workspace else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { _ in
            do {
                _ = try DataManager.shared().deleteWorkspace(workspace)
            } catch {
                let alertController = UIAlertController(
                    title: "Could not delete this workspace".localized(),
                    message: "The app could not delete the workspace".localized() + workspace.name,
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
}
