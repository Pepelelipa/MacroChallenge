//
//  WorkspaceSelectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

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
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID)

        return collectionView
    }()
    private lazy var collectionDelegate = WorkspaceCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let workspace = selectedCell.workspace else {
            fatalError("The workspace cell did not have a workspace")
        }

        let notebooksSelectionView = NotebooksSelectionViewController(workspace: workspace)

        self.navigationController?.pushViewController(notebooksSelectionView, animated: true)
    }
    private let collectionDataSource = WorkspacesCollectionViewDataSource()

    override func viewDidLoad() {
        view.backgroundColor = .rootColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Workspaces".localized()
        view.addSubview(collectionView)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
