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
    }

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)

        lbl.textColor = .black
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random()
        addSubview(lblWorkspaceName)
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
            lblWorkspaceName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lblWorkspaceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lblWorkspaceName.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            lblWorkspaceName.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
