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
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: 50, height: 50)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let dataSource = WorkspaceCollectionViewDataSource()
    private let flowLayoutDelegate = WorkspaceCollectionViewFlowLayoutDelegate()

    override func viewDidLoad() {
        view.backgroundColor = .random()
        setupLblName()
        setupCollectionView()
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
        collectionView.delegate = flowLayoutDelegate
        collectionView.dataSource = dataSource

        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID)

        collectionView.backgroundColor = .white

        collectionView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lblName.topAnchor, constant: 50),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40),
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])

        collectionView.reloadData()
    }
}
