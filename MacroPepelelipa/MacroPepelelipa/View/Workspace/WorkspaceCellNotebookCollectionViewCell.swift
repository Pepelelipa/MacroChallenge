//
//  WorkspaceCellNotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceCellNotebookCollectionViewCell: UICollectionViewCell {
    internal class func cellID() -> String { "workspaceCellNotebookCell" }

    private let notebookView = NotebookView(frame: .zero)
    public var color: UIColor {
        get {
            return notebookView.color
        }
        set {
            notebookView.color = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notebookView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            notebookView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notebookView.centerYAnchor.constraint(equalTo: centerYAnchor),
            notebookView.widthAnchor.constraint(equalTo: widthAnchor),
            notebookView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
}
