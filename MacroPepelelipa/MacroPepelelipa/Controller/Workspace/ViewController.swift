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
//    private var collectionView: UICollectionView

    override func viewDidLoad() {
        view.backgroundColor = .random()
        setupLblName()
    }

    private func setupLblName() {
        lblName.text = "Coleçãum"
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
}
