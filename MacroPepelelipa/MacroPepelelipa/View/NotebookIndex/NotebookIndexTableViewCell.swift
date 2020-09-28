//
//  NotebookIndexTableViewCell.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookIndexTableViewCell: UITableViewCell {
    private let index: NotebookIndexEntity

    private let lessonLbl: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    ///Title of the lesson
    internal var indexText: String? {
        get {
            return lessonLbl.text
        }
        set {
            lessonLbl.text = newValue
        }
    }

    init(index: NotebookIndexEntity) {
        self.index = index
        super.init(style: .default, reuseIdentifier: nil)
        self.backgroundColor = UIColor(named: "Background")

        contentView.addSubview(lessonLbl)
        indexText = index.index
        setupConstraints()
    }

    required convenience init?(coder: NSCoder) {
        guard let index = coder.decodeObject(forKey: "index") as? NotebookIndexEntity else {
            return nil
        }
        self.init(index: index)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lessonLbl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            lessonLbl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lessonLbl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            lessonLbl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            lessonLbl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
