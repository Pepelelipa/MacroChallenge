//
//  CollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceViewController: UIViewController {
    private var lblName: UILabel = {
        let lblName = UILabel()
        lblName.text = "Workspace".localized()
        lblName.font = .preferredFont(forTextStyle: .title1)
        lblName.textAlignment = .center
        lblName.translatesAutoresizingMaskIntoConstraints = false

        return lblName
    }()
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 157.5, height: 230)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false

        collectionView.delegate = flowLayoutDelegate
        collectionView.dataSource = dataSource

        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID)

        return collectionView
    }()
    private let dataSource = WorkspaceCollectionViewDataSource()
    private lazy var flowLayoutDelegate = WorkspaceCollectionViewFlowLayoutDelegate { (selectedCell) in
        let split = SplitViewController()

        #warning("Fade animation as placeholder for Books animation.")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(split, animated: false)
    }

    override func viewDidLoad() {
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
