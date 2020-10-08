//
//  AddWorkspaceViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddWorkspaceViewController: PopupContainerViewController, AddWorkspaceObserver {

    private lazy var txtName: UITextField = {
        let txtName = UITextField()
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.placeholder = "New workspace name".localized()
        txtName.borderStyle = .none
        txtName.font = .preferredFont(forTextStyle: .title1)
        txtName.tintColor = .actionColor
        txtName.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        txtName.returnKeyType = UIReturnKeyType.done
        txtName.delegate = txtNoteDelegate

        return txtName
    }()   
    
    private lazy var txtNoteDelegate: AddNewSpaceTextFieldDelegate = {
        let delegate = AddNewSpaceTextFieldDelegate()
        delegate.observer = self
        return delegate
    }()
    
    private lazy var keyboardToolBar = AddNewSpaceToolBar(frame: .zero, owner: txtName)
    
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

    internal override func moveTo(_ viewController: UIViewController) {
        let centerYConstraint = view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        self.centerYConstraint = centerYConstraint
        super.moveTo(viewController)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            centerYConstraint,
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            view.heightAnchor.constraint(greaterThanOrEqualTo: viewController.view.heightAnchor, multiplier: 0.18),
            view.widthAnchor.constraint(lessThanOrEqualTo: viewController.view.widthAnchor, multiplier: 0.8)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(txtName)
        view.addSubview(btnConfirm)
        btnConfirm.isEnabled = false

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        view.addGestureRecognizer(selfTapGestureRecognizer)
        txtName.becomeFirstResponder()
        self.txtName.inputAccessoryView = keyboardToolBar
    }

    @IBAction func selfTap() {
        txtName.resignFirstResponder()
    }

    var centerYConstraint: NSLayoutConstraint?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            txtName.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            txtName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            txtName.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            btnConfirm.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            btnConfirm.topAnchor.constraint(greaterThanOrEqualTo: txtName.bottomAnchor, constant: 30),
            btnConfirm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnConfirm.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            btnConfirm.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            centerYConstraint?.constant = -keyboardSize.height*0.5
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        centerYConstraint?.constant = 0
    }

    // MARK: UIControls Events
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
            _ = Mockdata.createWorkspace(named: text)
            dismissFromParent()
        }
    }
    func addWorkspace() {
        btnConfirmTap()
    }
    override func backgroundTap() {
        if txtName.isEditing {
            txtName.endEditing(true)
        } else {
            super.backgroundTap()
        }
    }
}
