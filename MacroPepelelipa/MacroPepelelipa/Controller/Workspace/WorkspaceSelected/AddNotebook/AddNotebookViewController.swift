//
//  AddNotebookViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddNotebookViewController: PopupContainerViewController {
    private weak var workspace: WorkspaceEntity?

    init(workspace: WorkspaceEntity?, dismissHandler: (() -> Void)? = nil) {
        super.init(dismissHandler: dismissHandler)
        self.workspace = workspace
    }

    required convenience init?(coder: NSCoder) {
        guard let workspace = coder.decodeObject(forKey: "workspace") as? WorkspaceEntity else {
            return nil
        }
        self.init(workspace: workspace, dismissHandler: coder.decodeObject(forKey: "dismissHandler") as? () -> Void)
    }

    private lazy var txtName: UITextField = {
        let txtName = UITextField()
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.placeholder = "New notebook name".localized()
        txtName.borderStyle = .none
        txtName.font = .preferredFont(forTextStyle: .title1)
        txtName.tintColor = .actionColor
        txtName.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

        return txtName
    }()

    private let notebookView = NotebookView(frame: .zero)

    private lazy var btnConfirm: UIButton = {
        let btnConfirm = UIButton()
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.setTitle("Create new notebook".localized(), for: .normal)
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.tintColor = .white
        btnConfirm.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        btnConfirm.layer.cornerRadius = 22

        return btnConfirm
    }()

    override func moveTo(_ viewController: UIViewController) {
        super.moveTo(viewController)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.7),
            view.widthAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.78),
            view.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = UIColor.randomNotebookColor() {
            notebookView.color = color
        }
        view.addSubview(txtName)
        view.addSubview(notebookView)
        view.addSubview(btnConfirm)
        btnConfirm.isEnabled = false

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        view.addGestureRecognizer(selfTapGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            txtName.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            txtName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            notebookView.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: 30),
            notebookView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notebookView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            notebookView.widthAnchor.constraint(equalTo: notebookView.heightAnchor, multiplier: 0.75)
        ])

        NSLayoutConstraint.activate([
            btnConfirm.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            btnConfirm.topAnchor.constraint(greaterThanOrEqualTo: txtName.topAnchor, constant: 30),
            btnConfirm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnConfirm.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            btnConfirm.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    private func checkBtnEnabled() {
        btnConfirm.isEnabled = txtName.text != ""
    }

    // MARK: UIControls Events
    @IBAction func selfTap() {
        txtName.resignFirstResponder()
    }

    @IBAction func textChanged(_ textField: UITextField) {
        let trimmed = textField.text?.trimmingCharacters(in: .whitespaces)
        if trimmed == "" {
            textField.text = trimmed
        }
        guard textField.text != nil else {
            btnConfirm.isEnabled = false
            return
        }
        checkBtnEnabled()
    }

    @IBAction func btnConfirmTap() {
        guard let workspace = workspace, let text = txtName.text else {
            fatalError("Deu ruim")
        }
        _ = Mockdata.createNotebook(on: workspace, named: text, colorName: "")
        dismissFromParent()
    }
}
