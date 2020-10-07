//
//  AddWorkspaceViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddWorkspaceViewController: UIViewController {

    private var dismissHandler: (() -> Void)?
    internal init(dismissHandler: (() -> Void)? = nil) {
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
    }
    
    required convenience init?(coder: NSCoder) {
        guard let dismissHandler = coder.decodeObject(forKey: "dismissHandler") as? () -> Void else {
            return nil
        }

        self.init(dismissHandler: dismissHandler)
    }

    private lazy var txtName: UITextField = {
        let txtName = UITextField()
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.placeholder = "New workspace name".localized()
        txtName.borderStyle = .none
        txtName.font = .preferredFont(forTextStyle: .title1)
        txtName.tintColor = .actionColor
        txtName.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

        return txtName
    }()
    private lazy var btnConfirm: UIButton = {
        let btnConfirm = UIButton()
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.setTitle("Create new workspace".localized(), for: .normal)
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.tintColor = .white
        btnConfirm.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        btnConfirm.layer.cornerRadius = 22

        return btnConfirm
    }()

    override func viewDidLoad() {
        view.addSubview(txtName)
        btnConfirm.isEnabled = false
        view.addSubview(btnConfirm)
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            txtName.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            txtName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
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

    var backgroundBlur: UIView?
    internal func moveTo(_ viewController: UIViewController) {
        willMove(toParent: viewController)
        let backgroundBlur = UIView()
        self.backgroundBlur = backgroundBlur
        backgroundBlur.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlur.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        viewController.view.addSubview(backgroundBlur)
        NSLayoutConstraint.activate([
            backgroundBlur.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            backgroundBlur.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            backgroundBlur.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
            backgroundBlur.heightAnchor.constraint(equalTo: viewController.view.heightAnchor)
        ])

        viewController.addChild(self)
        viewController.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            view.heightAnchor.constraint(greaterThanOrEqualTo: viewController.view.heightAnchor, multiplier: 0.18),
            view.widthAnchor.constraint(lessThanOrEqualTo: viewController.view.widthAnchor, multiplier: 0.8)
        ])

        didMove(toParent: viewController)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundBlur.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func backgroundTap() {
        dismissFromParent()
    }
    @IBAction func textChanged(_ textField: UITextField) {
        let trimmed = textField.text?.trimmingCharacters(in: .whitespaces)
        if trimmed == "" {
            textField.text = trimmed
        }
        guard let text = textField.text else {
            btnConfirm.isEnabled = false
            return
        }
        btnConfirm.isEnabled = !text.isEmpty
    }
    @IBAction func btnConfirmTap() {
        if let text = txtName.text {
            _ = Mockdata.createWorkspace(with: text)
            dismissFromParent()
        }
    }

    func dismissFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        didMove(toParent: nil)
        view.removeFromSuperview()
        backgroundBlur?.removeFromSuperview()
        dismissHandler?()
    }
}
