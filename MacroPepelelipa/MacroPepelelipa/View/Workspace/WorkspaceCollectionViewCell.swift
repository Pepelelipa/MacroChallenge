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
                NSLayoutConstraint.deactivate(notEditingConstraints)
                collectionView.removeFromSuperview()
                NSLayoutConstraint.activate(editingConstraints)
                if workspace?.isEnabled ?? false {
                    disclosureIndicator.isHidden = false
                }
                minusIndicator.isHidden = false
                lblWorkspaceName.accessibilityHint = "Edit workspace name hint".localized()
            } else {
                NSLayoutConstraint.deactivate(editingConstraints)
                addSubview(collectionView)
                NSLayoutConstraint.activate(notEditingConstraints)
                minusIndicator.isHidden = true
                disclosureIndicator.isHidden = true
                lblWorkspaceName.accessibilityHint = "Long press hint".localized()
            }

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    internal var entityShouldBeDeleted: ((ObservableEntity) -> Void)?
    
    private var dataSource: WorkspaceCellNotebookCollectionViewDataSource?
    private var delegate: WorkspaceCellNotebookCollectionViewDelegate?

    private lazy var minusIndicator: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = UIColor.notebookColors[15]
        button.isHidden = true

        button.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)

        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = UIFont.defaultHeader.toStyle(.h3)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.accessibilityHint = "Long press hint".localized()

        return lbl
    }()

    private var disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .actionColor
        imageView.isHidden = true

        imageView.isAccessibilityElement = false
        
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
        collectionView.isAccessibilityElement = false

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate

        collectionView.register(
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())

        return collectionView
    }()

    private lazy var editingConstraints: [NSLayoutConstraint] = {
        [
            lblWorkspaceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            lblWorkspaceName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }()

    private lazy var notEditingConstraints: [NSLayoutConstraint] = {
        [
            lblWorkspaceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lblWorkspaceName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
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
            
            if let name = workspace?.name {
                self.minusIndicator.accessibilityHint = String(format: "Delete workspace hint".localized(), name)
                self.minusIndicator.accessibilityLabel = String(format: "Delete workspace label".localized(), name)
            }
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
            lblWorkspaceName.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

            minusIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            minusIndicator.heightAnchor.constraint(equalToConstant: 20),
            minusIndicator.widthAnchor.constraint(equalTo: minusIndicator.heightAnchor, multiplier: 1),

            disclosureIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 30),
            disclosureIndicator.widthAnchor.constraint(equalTo: disclosureIndicator.heightAnchor, multiplier: 0.6)

        ])

        NSLayoutConstraint.activate(notEditingConstraints)
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

    @objc internal func deleteTap() {
        if let workspace = workspace {
            entityShouldBeDeleted?(workspace)
        }
    }
}
