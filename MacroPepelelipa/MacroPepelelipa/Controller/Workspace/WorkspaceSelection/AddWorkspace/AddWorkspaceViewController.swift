//
//  AddWorkspaceViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddWorkspaceViewController: ViewController, AddWorkspaceObserver {
    
    // MARK: - Variables and Constants
    
    internal weak var workspace: WorkspaceEntity?
    
    private lazy var popupViewCenterYConstraint = popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    
    private lazy var gestureDelegate: GestureDelegate = GestureDelegate(popup: popupView, textField: txtName)
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var txtName: UITextField = {
        let txtName = UITextField()
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.placeholder = "New workspace name".localized()
        txtName.adjustsFontSizeToFitWidth = true
        txtName.borderStyle = .none
        txtName.font = UIFont.defaultHeader.toStyle(.h3)
        txtName.tintColor = .actionColor
        txtName.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        txtName.returnKeyType = UIReturnKeyType.done
        txtName.delegate = txtNoteDelegate

        return txtName
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.placeholderColor
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissPopUpView), for: .touchUpInside)
        button.accessibilityLabel = "Dismiss pop-up label".localized()
        button.accessibilityHint = "Dismiss collection pop-up hint".localized()
        return button
    }()
    
    private lazy var txtNoteDelegate: AddNewSpaceTextFieldDelegate = {
        let delegate = AddNewSpaceTextFieldDelegate()
        delegate.workspaceObserver = self
        return delegate
    }()
    
    private lazy var keyboardToolBar = AddNewSpaceToolBar(frame: .zero, owner: txtName)
    
    private lazy var btnConfirm: UIButton = {
        let btnConfirm = RoundCornerButton(textColor: UIColor(named: "Action"), fillColor: .clear, borderColor: UIColor(named: "Action"), cornerRadius: 10)
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.setTitle("Create new workspace".localized(), for: .normal)
        btnConfirm.titleLabel?.adjustsFontSizeToFitWidth = true
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3).removeTrait(.traitBold)
        btnConfirm.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        return btnConfirm
    }()

    private lazy var constraints: [NSLayoutConstraint] = {
        [
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupViewCenterYConstraint,
            popupView.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            popupView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.18),
            popupView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            
            dismissButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.15),
            dismissButton.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.15),
            
            txtName.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 5),
            txtName.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            txtName.heightAnchor.constraint(equalToConstant: 40),

            btnConfirm.bottomAnchor.constraint(lessThanOrEqualTo: popupView.bottomAnchor, constant: -20),
            btnConfirm.topAnchor.constraint(greaterThanOrEqualTo: txtName.bottomAnchor, constant: 25),
            btnConfirm.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45),
            btnConfirm.leadingAnchor.constraint(greaterThanOrEqualTo: popupView.leadingAnchor, constant: 40),
            btnConfirm.trailingAnchor.constraint(lessThanOrEqualTo: popupView.trailingAnchor, constant: -40)
        ]
    }()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        
        view.addSubview(popupView)
        popupView.addSubview(txtName)
        popupView.addSubview(btnConfirm)
        popupView.addSubview(dismissButton)
        btnConfirm.isEnabled = false

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        selfTapGestureRecognizer.delegate = gestureDelegate
        view.addGestureRecognizer(selfTapGestureRecognizer)
        
        self.txtName.inputAccessoryView = keyboardToolBar

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let workspace = workspace {
            txtName.text = workspace.name
            btnConfirm.setTitle("Save Workspace".localized(), for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate(constraints)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else {
            return
        }

        switch key.keyCode {
        case .keyboardEscape:
            self.dismiss(animated: true, completion: nil)
        default:
            super.pressesBegan(presses, with: event)
        }
    }

    // MARK: - AddWorkspaceObserver functions
    
    ///A  method tthat calls btn Confirm Tap.
    func addWorkspace() {
        btnConfirmTap()
    }
    
    // MARK: - IBActions functions
    
    @IBAction func dismissPopUpView() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func selfTap() {
        self.txtName.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmTap() {
        if let text = txtName.text {
            do {
                if let workspace = workspace {
                    workspace.name = text
                } else {
                    _ = try DataManager.shared().createWorkspace(named: text)
                }
            } catch {
                let title = "Error creating the workspace".localized()
                let message = "A new Workspace could not be created".localized()
                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            }
            
            self.dismiss(animated: true) { 
                if self.txtName.isEditing {
                    self.txtName.endEditing(true)
                } 
            }
        }
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
    
    // MARK: - Objective-C functions

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            popupViewCenterYConstraint.constant = -keyboardSize.height*0.5
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        popupViewCenterYConstraint.constant = 0
    }
}
