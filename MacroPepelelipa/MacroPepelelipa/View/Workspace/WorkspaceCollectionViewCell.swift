//
//  WorkspaceCollectionnViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspaceCollectionViewCell: UICollectionViewCell {
    internal static let cellID = "workspaceCell"
    
    internal private(set) weak var workspace: WorkspaceEntity? {
        didSet {
            self.lblWorkspaceName.text = workspace?.name
        }
    }
    internal func setWorkspace(_ workspace: WorkspaceEntity) {
        self.workspace = workspace
        dataSource = .init(workspace: workspace)
        delegate = .init(totalNotebooks: workspace.notebooks.count)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.reloadData()
    }

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)

        lbl.textColor = .black
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate

        collectionView.register(
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID)

        return collectionView
    }()
    private var dataSource: WorkspaceCellNotebookCollectionViewDataSource?
    private var delegate: WorkspaceCellNotebookCollectionViewDelegate?
    internal func reloadData() {
        collectionView.reloadData()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(lblWorkspaceName)
        addSubview(collectionView)
        collectionView.register(
            WorkspaceCellNotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCellNotebookCollectionViewCell.cellID)
        setupConstraints()
        layer.cornerRadius = 10
    }
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lblWorkspaceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lblWorkspaceName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lblWorkspaceName.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            lblWorkspaceName.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lblWorkspaceName.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            collectionView.widthAnchor.constraint(greaterThanOrEqualTo: collectionView.heightAnchor, multiplier: 2)
        ])
    }
}