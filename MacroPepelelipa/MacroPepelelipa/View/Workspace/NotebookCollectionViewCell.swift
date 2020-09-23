//
//  NotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

#warning("Notebook Collection View Cell has no actual information yet.")
internal class NotebookCollectionViewCell: UICollectionViewCell {
    internal static let cellID = "notebookCell"
    private let lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.text = "Notebook".localized()
        lbl.textColor = .black
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    internal var text: String? {
        get {
            return lblName.text
        }
        set {
            lblName.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random()
        addSubview(lblName)
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
            lblName.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor),
            lblName.widthAnchor.constraint(equalToConstant: 100),
            lblName.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
