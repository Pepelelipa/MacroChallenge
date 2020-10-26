//
//  WorkspaceCollectionnViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspaceCollectionViewCell: UICollectionViewCell, EditableCollectionViewCell {
    // MARK: - Variables and Constants

    internal var isEditing: Bool = false {
        didSet {
            if isEditing {
                NSLayoutConstraint.deactivate(collectionViewConstraints)
                collectionView.removeFromSuperview()
                disclosureIndicator.isHidden = false
                minusIndicator.isHidden = false
                lblLeadingConstraint.constant = 60
            } else {
                addSubview(collectionView)
                NSLayoutConstraint.activate(collectionViewConstraints)
                minusIndicator.isHidden = true
                disclosureIndicator.isHidden = true
                lblLeadingConstraint.constant = 20
            }

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    private var dataSource: WorkspaceCellNotebookCollectionViewDataSource?
    private var delegate: WorkspaceCellNotebookCollectionViewDelegate?

    private var minusIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
        imageView.tintColor = UIColor.notebookColors[15]
        imageView.isHidden = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)

        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = MarkdownHeader.thirdHeaderFont
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    private var disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .actionColor
        imageView.isHidden = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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

    private lazy var lblLeadingConstraint: NSLayoutConstraint = lblWorkspaceName.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: 20)

    private lazy var collectionViewConstraints: [NSLayoutConstraint] = {
        [
            collectionView.topAnchor.constraint(equalTo: lblWorkspaceName.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.widthAnchor.constraint(greaterThanOrEqualTo: collectionView.heightAnchor, multiplier: 2)
        ]
    }()

    internal private(set) weak var workspace: WorkspaceEntity? {
        didSet {
            self.lblWorkspaceName.text = workspace?.name
        }
    }
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(minusIndicator)
        addSubview(lblWorkspaceName)
        addSubview(disclosureIndicator)
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
            lblLeadingConstraint,
            lblWorkspaceName.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            lblWorkspaceName.heightAnchor.constraint(equalToConstant: 30),

            minusIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            minusIndicator.heightAnchor.constraint(equalToConstant: 20),
            minusIndicator.widthAnchor.constraint(equalTo: minusIndicator.heightAnchor, multiplier: 1),

            disclosureIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 30),
            disclosureIndicator.widthAnchor.constraint(equalTo: disclosureIndicator.heightAnchor, multiplier: 0.6)

        ])

        NSLayoutConstraint.activate(collectionViewConstraints)
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
