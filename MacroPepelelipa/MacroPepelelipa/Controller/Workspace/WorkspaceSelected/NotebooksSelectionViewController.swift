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
    }
    internal required convenience init?(coder: NSCoder) {
        guard let workspace = coder.decodeObject(forKey: "workspace") as? WorkspaceEntity else {
            return nil
        }
        self.init(workspace: workspace)
    }

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
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID())

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

    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        return item
    }()
    @IBAction func btnAddTap() {
        btnAdd.isEnabled = false
        let backBar = navigationItem.backBarButtonItem
        navigationItem.hidesBackButton = true
        let addController = AddNotebookViewController(dismissHandler: {
            self.btnAdd.isEnabled = true
            self.navigationItem.hidesBackButton = false
        })
        addController.moveTo(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = btnAdd
        navigationItem.title = workspace?.name
        view.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
