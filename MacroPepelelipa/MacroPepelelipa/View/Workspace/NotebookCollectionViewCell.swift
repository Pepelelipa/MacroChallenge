//
//  NotebookCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookCollectionViewCell: UICollectionViewCell, EditableCollectionViewCell {
    
    // MARK: - Variables and Constants

    internal var isEditing: Bool = false {
        didSet {
            if isEditing {
                layer.cornerRadius = 13
                backgroundColor = UIColor(named: notebook?.colorName ?? "")
                lblName.tintColor = .backgroundColor
                NSLayoutConstraint.deactivate(notEditingConstraints)
                notebookView.removeFromSuperview()
                NSLayoutConstraint.activate(editingConstraints)
                if (try? notebook?.getWorkspace().isEnabled) ?? false {
                    disclosureIndicator.isHidden = false
                    minusIndicator.isHidden = false
                }
            } else {
                layer.cornerRadius = 0
                backgroundColor = .backgroundColor
                lblName.tintColor = .titleColor
                NSLayoutConstraint.deactivate(editingConstraints)
                addSubview(notebookView)
                NSLayoutConstraint.activate(notEditingConstraints)
                minusIndicator.isHidden = true
                disclosureIndicator.isHidden = true
            }
        }
    }
    internal var entityShouldBeDeleted: ((ObservableEntity) -> Void)?
    internal var text: String? {
        get {
            return lblName.text
        }
        set {
            lblName.text = newValue
        }
    }

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

    private let lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = MarkdownHeader.thirdHeaderFont
        lbl.textAlignment = .left
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
    
    private lazy var notebookView: NotebookView = {
        let notebook = NotebookView(frame: .zero)
        if let color = UIColor(named: self.notebook?.colorName ?? "") {
            notebook.color = color
        }
        return notebook
    }()

    private lazy var editingConstraints: [NSLayoutConstraint] = {
        [
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor),
            lblName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60)
        ]
    }()
    private lazy var notEditingConstraints: [NSLayoutConstraint] = {
        [
            notebookView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notebookView.topAnchor.constraint(equalTo: topAnchor),
            notebookView.widthAnchor.constraint(equalTo: widthAnchor),
            notebookView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            lblName.centerYAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: 20),
            lblName.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor)
        ]
    }()

    private lazy var minusIndicator: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = UIColor.notebookColors[15]
        button.isHidden = true

        button.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(notebookView)
        addSubview(minusIndicator)
        addSubview(lblName)
        addSubview(disclosureIndicator)
        setupConstraints()
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Functions

    private func setupConstraints() {
        NSLayoutConstraint.activate(notEditingConstraints)
        NSLayoutConstraint.activate([
            lblName.widthAnchor.constraint(equalTo: widthAnchor),

            minusIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            minusIndicator.heightAnchor.constraint(equalToConstant: 20),
            minusIndicator.widthAnchor.constraint(equalTo: minusIndicator.heightAnchor, multiplier: 1),

            disclosureIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 30),
            disclosureIndicator.widthAnchor.constraint(equalTo: disclosureIndicator.heightAnchor, multiplier: 0.6)
        ])
    }
    
    internal class func cellID() -> String {
        "notebookCell"
    }
    
    internal func setNotebook(_ notebook: NotebookEntity) {
        self.notebook = notebook
    }

    @objc internal func deleteTap() {
        if let notebook = notebook {
            entityShouldBeDeleted?(notebook)
        }
    }
}
