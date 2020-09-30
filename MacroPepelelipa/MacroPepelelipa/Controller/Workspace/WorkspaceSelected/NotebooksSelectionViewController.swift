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
    internal private(set) weak var workspace: WorkspaceEntity?
    internal init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        self.collectionDataSource = NotebooksCollectionViewDataSource(workspace: workspace)
        super.init(nibName: nil, bundle: nil)
        lblName.text = workspace.name
    }
    internal required convenience init?(coder: NSCoder) {
        guard let workspace = coder.decodeObject(forKey: "workspace") as? WorkspaceEntity else {
            return nil
        }
        self.init(workspace: workspace)
    }

    private var lblName: UILabel = {
        let lblName = UILabel()
        lblName.font = .preferredFont(forTextStyle: .title1)
        lblName.textAlignment = .center
        lblName.translatesAutoresizingMaskIntoConstraints = false

        return lblName
    }()
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
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID)

        return collectionView
    }()
    private let collectionDataSource: NotebooksCollectionViewDataSource
    private lazy var collectionDelegate = NotebooksCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let notebook = selectedCell.notebook else {
            fatalError("The notebook cell did not have a notebook")
        }
        let split = SplitViewController(notebook: notebook)

        #warning("Fade animation as placeholder for Books animation.")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(split, animated: false)
    }

    override func viewDidLoad() {
        navigationItem.title = workspace?.name
        view.backgroundColor = .random()
        view.addSubview(lblName)
        view.addSubview(collectionView)
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            lblName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            lblName.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            lblName.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lblName.topAnchor, constant: 50),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
}
