//
//  NotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookCollectionViewCell: UICollectionViewCell {
    internal static let cellID = "notebookCell"
    private let lblName = UILabel(frame: .zero)

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
        setupLabel()
    }
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }

    private func setupLabel() {
        lblName.text = "Teste"
        addSubview(lblName)
        NSLayoutConstraint.activate([
            lblName.widthAnchor.constraint(equalToConstant: 50),
            lblName.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
