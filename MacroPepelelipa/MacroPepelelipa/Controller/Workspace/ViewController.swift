//
//  CollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceViewController: UIViewController {
    private var lblName: UILabel = UILabel(frame: .zero)
    private var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 157.5, height: 230)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let dataSource = WorkspaceCollectionViewDataSource()
    private lazy var flowLayoutDelegate = WorkspaceCollectionViewFlowLayoutDelegate { (selectedCell) in
        #warning("Notebook view is a placeholder only.")
        let test = UIViewController()
        test.view.backgroundColor = selectedCell.backgroundColor
        self.navigationController?.pushViewController(test, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        view.backgroundColor = .random()
        setupLblName()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setupLblName() {
        lblName.text = "Coleção"
        view.addSubview(lblName)
        lblName.font = .preferredFont(forTextStyle: .title1)
        lblName.textAlignment = .center
        lblName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lblName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            lblName.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            lblName.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    private func setupCollectionView() {
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false

        collectionView.delegate = flowLayoutDelegate
        collectionView.dataSource = dataSource

        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID)

        collectionView.layoutMargins = .init(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lblName.topAnchor, constant: 50),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40),
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])

    }
}