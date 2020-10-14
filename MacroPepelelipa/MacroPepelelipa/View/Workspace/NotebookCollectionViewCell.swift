//
//  NotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookCollectionViewCell: UICollectionViewCell {
    internal class func cellID() -> String { "notebookCell" }

    internal private(set) weak var notebook: NotebookEntity? {
        didSet {
            DispatchQueue.main.async {
                self.text = self.notebook?.name
                if let colorName = self.notebook?.colorName,
                   let color = UIColor(named: colorName) {
                    self.notebookView.color = color
                }
            }
        }
    }
    internal func setNotebook(_ notebook: NotebookEntity) {
        self.notebook = notebook
    }
    private let lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = MarkdownHeader.thirdHeaderFont
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    private lazy var notebookView: NotebookView = {
        let notebook = NotebookView(frame: .zero)
        if let color = UIColor(named: self.notebook?.colorName ?? "") {
            notebook.color = color
        }
        return notebook
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
        backgroundColor = .backgroundColor
        addSubview(notebookView)
        addSubview(lblName)
        setupConstraints()
    }
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            notebookView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notebookView.topAnchor.constraint(equalTo: topAnchor),
            notebookView.widthAnchor.constraint(equalTo: widthAnchor),
            notebookView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])

        NSLayoutConstraint.activate([
            lblName.centerYAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: 20),
            lblName.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor),
            lblName.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
