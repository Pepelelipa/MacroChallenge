//
//  WorkspaceCollectionnViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
// swiftlint:disable function_body_length

import UIKit
import Database

internal class WorkspaceCollectionViewCell: UICollectionViewCell, EditableCollectionViewCell {
    
    // MARK: - Variables and Constants
    
    private var workspaceNotebooksConstraints: [NSLayoutConstraint] = []
    
    internal var isEditing: Bool = false {
        didSet {
            if isEditing {
                NSLayoutConstraint.deactivate(notEditingConstraints)
                workspaceView.removeFromSuperview()
                NSLayoutConstraint.activate(editingConstraints)
                if workspace?.isEnabled ?? false {
                    disclosureIndicator.isHidden = false
                }
                minusIndicator.isHidden = false
                lblWorkspaceName.accessibilityHint = "Edit workspace name hint".localized()
            } else {
                NSLayoutConstraint.deactivate(editingConstraints)
                addSubview(workspaceView)
                NSLayoutConstraint.activate(notEditingConstraints)
                NSLayoutConstraint.activate(workspaceNotebooksConstraints)
                minusIndicator.isHidden = true
                disclosureIndicator.isHidden = true
                lblWorkspaceName.accessibilityHint = "Long press hint".localized()
            }
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    internal var entityShouldBeDeleted: ((ObservableEntity) -> Void)?
    
    private lazy var workspaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    internal private(set) var lblWorkspaceName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = UIFont.defaultHeader.toStyle(.h3)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.accessibilityHint = "Long press hint".localized()

        return lbl
    }()
    
    private var disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .actionColor
        imageView.isHidden = true

        imageView.isAccessibilityElement = false
        
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
            workspaceView.topAnchor.constraint(equalTo: lblWorkspaceName.bottomAnchor, constant: 20),
            workspaceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            workspaceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workspaceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
    }()
    
    internal private(set) weak var workspace: WorkspaceEntity? {
        didSet {
            self.lblWorkspaceName.text = workspace?.name
            
            if let name = workspace?.name {
                self.minusIndicator.accessibilityHint = String(format: "Delete workspace hint".localized(), name)
                self.minusIndicator.accessibilityLabel = String(format: "Delete workspace label".localized(), name)
            }
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
        return notebookView
    }
    
    private func generateVerticalStack(colors: (top: UIColor, bottom: UIColor)) -> UIStackView {
        
        let verticalSV = UIStackView()
        verticalSV.axis = .vertical
        verticalSV.alignment = .center
        verticalSV.distribution = .fillEqually
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        
        let topNotebook = generateNotebook(color: colors.top)
        workspaceNotebooksConstraints.append(topNotebook.widthAnchor.constraint(equalTo: workspaceView.heightAnchor, multiplier: 0.35))
        
        let bottomNotebook = generateNotebook(color: colors.bottom)
        workspaceNotebooksConstraints.append(bottomNotebook.widthAnchor.constraint(equalTo: workspaceView.heightAnchor, multiplier: 0.35))
        
        verticalSV.addArrangedSubview(topNotebook)
        verticalSV.addArrangedSubview(bottomNotebook)
        
        return verticalSV
    }
    
    private func setupWorkspaceView() {
        workspaceNotebooksConstraints = []
        
        workspaceView.removeFromSuperview()
        for subview in workspaceView.subviews {
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
        workspaceView.addSubview(firstNotebook)
        workspaceNotebooksConstraints.append(firstNotebook.topAnchor.constraint(equalTo: workspaceView.topAnchor))
        workspaceNotebooksConstraints.append(firstNotebook.bottomAnchor.constraint(equalTo: workspaceView.bottomAnchor))
        workspaceNotebooksConstraints.append(firstNotebook.leadingAnchor.constraint(equalTo: workspaceView.leadingAnchor))
        workspaceNotebooksConstraints.append(firstNotebook.widthAnchor.constraint(equalTo: firstNotebook.heightAnchor, multiplier: 0.75))
        
        if colors.count < 5 {
            
            let auxiliarView = UIView()
            auxiliarView.backgroundColor = .clear
            auxiliarView.translatesAutoresizingMaskIntoConstraints = false
            workspaceView.addSubview(auxiliarView)
            
            let secondNotebook = generateNotebook(color: colors[1])
            auxiliarView.addSubview(secondNotebook)
            
            let verticalSV = generateVerticalStack(colors: (top: colors[2], bottom: colors[3]))
            verticalSV.alignment = .leading
            workspaceView.addSubview(verticalSV)
            
            workspaceNotebooksConstraints.append(auxiliarView.topAnchor.constraint(equalTo: workspaceView.topAnchor))
            workspaceNotebooksConstraints.append(auxiliarView.bottomAnchor.constraint(equalTo: workspaceView.bottomAnchor))
            workspaceNotebooksConstraints.append(auxiliarView.leadingAnchor.constraint(equalTo: firstNotebook.trailingAnchor))
            workspaceNotebooksConstraints.append(auxiliarView.trailingAnchor.constraint(equalTo: verticalSV.leadingAnchor))
            
            workspaceNotebooksConstraints.append(verticalSV.topAnchor.constraint(equalTo: workspaceView.topAnchor))
            workspaceNotebooksConstraints.append(verticalSV.bottomAnchor.constraint(equalTo: workspaceView.bottomAnchor))
            workspaceNotebooksConstraints.append(verticalSV.trailingAnchor.constraint(equalTo: workspaceView.trailingAnchor))
            workspaceNotebooksConstraints.append(verticalSV.widthAnchor.constraint(equalTo: secondNotebook.heightAnchor, multiplier: 0.375))
            
            workspaceNotebooksConstraints.append(secondNotebook.topAnchor.constraint(equalTo: auxiliarView.topAnchor))
            workspaceNotebooksConstraints.append(secondNotebook.bottomAnchor.constraint(equalTo: auxiliarView.bottomAnchor))
            workspaceNotebooksConstraints.append(secondNotebook.centerXAnchor.constraint(equalTo: auxiliarView.centerXAnchor))
            workspaceNotebooksConstraints.append(secondNotebook.widthAnchor.constraint(equalTo: auxiliarView.heightAnchor, multiplier: 0.75))
            
        } else {
            let horizontalSV = UIStackView()
            horizontalSV.alignment = .leading
            horizontalSV.distribution = .equalSpacing
            horizontalSV.axis = .horizontal
            horizontalSV.translatesAutoresizingMaskIntoConstraints = false
            
            let verticalSV1 = generateVerticalStack(colors: (top: colors[1], bottom: colors[2]))
            let verticalSV2 = generateVerticalStack(colors: (top: colors[3], bottom: colors[4]))
            let verticalSV3 = generateVerticalStack(colors: (top: colors[5], bottom: colors[6]))
            
            horizontalSV.addArrangedSubview(verticalSV1)
            horizontalSV.addArrangedSubview(verticalSV2)
            horizontalSV.addArrangedSubview(verticalSV3)
            workspaceView.addSubview(horizontalSV)
            
            workspaceNotebooksConstraints.append(verticalSV1.widthAnchor.constraint(equalTo: firstNotebook.heightAnchor, multiplier: 0.375))
            workspaceNotebooksConstraints.append(verticalSV2.widthAnchor.constraint(equalTo: firstNotebook.heightAnchor, multiplier: 0.375))
            workspaceNotebooksConstraints.append(verticalSV3.widthAnchor.constraint(equalTo: firstNotebook.heightAnchor, multiplier: 0.375))
            
            workspaceNotebooksConstraints.append(horizontalSV.topAnchor.constraint(equalTo: firstNotebook.topAnchor))
            workspaceNotebooksConstraints.append(horizontalSV.bottomAnchor.constraint(equalTo: firstNotebook.bottomAnchor))
            workspaceNotebooksConstraints.append(horizontalSV.leadingAnchor.constraint(equalTo: firstNotebook.trailingAnchor, constant: 10))
            workspaceNotebooksConstraints.append(horizontalSV.trailingAnchor.constraint(equalTo: workspaceView.trailingAnchor))
        }
    }
    
    internal class func cellID() -> String { 
        return "workspaceCell"
    }
    
    internal func updateLayout() {
        workspaceView.layoutIfNeeded()
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
