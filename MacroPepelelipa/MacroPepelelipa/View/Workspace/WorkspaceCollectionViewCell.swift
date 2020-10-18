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
    
    // MARK: - Variables and Constants
    
    private var dataSource: WorkspaceCellNotebookCollectionViewDataSource?
    private var delegate: WorkspaceCellNotebookCollectionViewDelegate?

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)

        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = MarkdownHeader.thirdHeaderFont
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    
    internal private(set) weak var workspace: WorkspaceEntity? {
        didSet {
            self.lblWorkspaceName.text = workspace?.name
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.isUserInteractionEnabled = false

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate

        collectionView.register(
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())

        return collectionView
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(lblWorkspaceName)
        addSubview(collectionView)
        collectionView.register(
            WorkspaceCellNotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCellNotebookCollectionViewCell.cellID())
        setupConstraints()
        layer.cornerRadius = 10
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Functions
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lblWorkspaceName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            lblWorkspaceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lblWorkspaceName.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            lblWorkspaceName.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lblWorkspaceName.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            collectionView.widthAnchor.constraint(greaterThanOrEqualTo: collectionView.heightAnchor, multiplier: 2)
        ])
    }
    
    internal class func cellID() -> String { 
        return "workspaceCell"
    }
    
    internal func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    internal func setWorkspace(_ workspace: WorkspaceEntity, viewController: UIViewController? = nil) {
        self.workspace = workspace
        dataSource = .init(workspace: workspace, viewController: viewController)
        delegate = .init(totalNotebooks: workspace.notebooks.count)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.reloadData()
    }
}
