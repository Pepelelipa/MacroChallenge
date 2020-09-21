//
//  NotebookIndexTableViewCell.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

#warning("Notebook TableView Cell has no actual information yet.")
internal class NotebookIndexTableViewCell: UITableViewCell {

    internal static let cellID = "notebookIndexCell"
    private let lessonLbl: UILabel = UILabel(frame: .zero)

    internal var lessonTitle: String? {
        get {
            return lessonLbl.text
        }
        set {
            lessonLbl.text = newValue
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .random()
        setupLabel()
    }

    required convenience init?(coder: NSCoder) {
        guard let style = coder.decodeObject(forKey: "style") as? UITableViewCell.CellStyle,
              let reuseIdentifier = coder.decodeObject(forKey: "reuseIdentifier") as? String else {
            return nil
        }
        self.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    private func setupLabel() {
        lessonTitle = "Lesson".localized()
        lessonLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lessonLbl)

        NSLayoutConstraint.activate([
            lessonLbl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            lessonLbl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            lessonLbl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            lessonLbl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
