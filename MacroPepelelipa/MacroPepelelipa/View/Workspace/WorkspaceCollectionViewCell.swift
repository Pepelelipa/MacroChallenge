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
                workspaceStackView.removeFromSuperview()
                NSLayoutConstraint.activate(editingConstraints)
                if workspace?.isEnabled ?? false {
                    disclosureIndicator.isHidden = false
                }
                minusIndicator.isHidden = false
            } else {
                NSLayoutConstraint.deactivate(editingConstraints)
                addSubview(workspaceStackView)
                NSLayoutConstraint.activate(notEditingConstraints)
                minusIndicator.isHidden = true
                disclosureIndicator.isHidden = true
            }

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    internal var entityShouldBeDeleted: ((ObservableEntity) -> Void)?
    
    private lazy var workspaceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

    private var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = UIFont.defaultHeader.toStyle(.h3)
        lbl.textAlignment = .center
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

    private lazy var editingConstraints: [NSLayoutConstraint] = {
        [
            lblWorkspaceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            lblWorkspaceName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }()

    private lazy var notEditingConstraints: [NSLayoutConstraint] = {
        [
            lblWorkspaceName.heightAnchor.constraint(equalToConstant: 30),
            lblWorkspaceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lblWorkspaceName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            workspaceStackView.topAnchor.constraint(equalTo: lblWorkspaceName.bottomAnchor, constant: 20),
            workspaceStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            workspaceStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workspaceStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
    }()

    internal private(set) weak var workspace: WorkspaceEntity? {
        didSet {
            self.lblWorkspaceName.text = workspace?.name
        }
    }
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .backgroundColor
        
        addSubview(minusIndicator)
        addSubview(lblWorkspaceName)
        addSubview(disclosureIndicator)
        
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
    }
    
    private func generateNotebook(color: UIColor) -> NotebookView {
        let notebookView = NotebookView(frame: .zero)
        notebookView.color = color
        notebookView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notebookView.widthAnchor.constraint(equalTo: notebookView.heightAnchor, multiplier: 0.75)
        ])
        return notebookView
    }
    
    private func setupWorkspaceView() {
        
        workspaceStackView.removeFromSuperview()
        for subview in workspaceStackView.subviews {
            subview.removeFromSuperview()
        }
        
        var colors: [UIColor] = []
        let defaultColor = UIColor.gray.withAlphaComponent(0.15)
        var defaultNotebooks = 4
        
        if let notebooks = workspace?.notebooks {
            let presentingNotebooks = notebooks.count < 7 ? notebooks.count : 7
            for i in 0..<presentingNotebooks {
                if let color = UIColor(named: notebooks[i].colorName) {
                    colors.append(color)
                } else {
                    break
                }
            }
            defaultNotebooks = colors.count > 4 ? 7 - colors.count : 4 - colors.count
        }
        
        for _ in 0..<defaultNotebooks {
            colors.append(defaultColor)
        }
        
        let firstNotebook = generateNotebook(color: colors.first ?? defaultColor)
        workspaceStackView.addArrangedSubview(firstNotebook)
        
        let start = colors.count > 4 ? 1 : 2
        
        if colors.count < 5 {
            let secondNotebook = generateNotebook(color: colors[1])
            workspaceStackView.addArrangedSubview(secondNotebook)
        }
        
        for i in stride(from: start, to: colors.count, by: 2) {
            let verticalSV = UIStackView()
            verticalSV.axis = .vertical
            verticalSV.alignment = .center
            verticalSV.distribution = .fillEqually
            verticalSV.spacing = 10
            verticalSV.addArrangedSubview(generateNotebook(color: colors[i]))
            verticalSV.addArrangedSubview(generateNotebook(color: colors[i+1]))
            workspaceStackView.addArrangedSubview(verticalSV)
        }
    }
    
    internal class func cellID() -> String { 
        return "workspaceCell"
    }
    
    internal func updateLayout() {
        workspaceStackView.layoutIfNeeded()
    }
    
    internal func setWorkspace(_ workspace: WorkspaceEntity, viewController: UIViewController? = nil) {
        self.workspace = workspace
        setupWorkspaceView()
    }
    
    // MARK: - Objective-C functions

    @objc internal func deleteTap() {
        if let workspace = workspace {
            entityShouldBeDeleted?(workspace)
        }
    }
}
