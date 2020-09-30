//
//  WorkspaceCellNotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceCellNotebookCollectionViewCell: UICollectionViewCell {
    internal static let cellID = "workspaceCellNotebookCell"

    private let shadowView = UIImageView(image: #imageLiteral(resourceName: "BooklikeShadow"))
    private let bookView = UIImageView(image: #imageLiteral(resourceName: "Book"))
    public var color: UIColor {
        get {
            return bookView.tintColor
        }
        set {
            shadowView.alpha = newValue.cgColor.alpha
            bookView.tintColor = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bookView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.contentMode = .scaleToFill
        bookView.contentMode = .scaleToFill
        bookView.addSubview(shadowView)
        addSubview(bookView)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.centerXAnchor.constraint(equalTo: bookView.centerXAnchor),
            shadowView.centerYAnchor.constraint(equalTo: bookView.centerYAnchor),
            shadowView.widthAnchor.constraint(equalTo: bookView.widthAnchor),
            shadowView.heightAnchor.constraint(equalTo: bookView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            bookView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bookView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }

    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
}
