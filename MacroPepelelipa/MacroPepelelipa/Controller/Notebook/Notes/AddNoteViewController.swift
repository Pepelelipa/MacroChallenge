//
//  AddNoteViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddNoteViewController: UIViewController, AddNoteObserver {
    
    // MARK: - Variables and Constants
    
    private var dismissHandler: (() -> Void)?
    private weak var notebook: NotebookEntity?
    
    internal var centerYConstraint: NSLayoutConstraint?
    
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
        txtName.placeholder = "New note title".localized()
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
        delegate.notesObserver = self
        return delegate
    }()
    
    private lazy var keyboardToolBar = AddNewSpaceToolBar(frame: .zero, owner: txtName)
    
    private lazy var btnConfirm: UIButton = {
        let btnConfirm = UIButton()
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.setTitle("Create new Note".localized(), for: .normal)
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.tintColor = .white
        btnConfirm.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        btnConfirm.layer.cornerRadius = 22

        return btnConfirm
    }()

    private lazy var constraints: [NSLayoutConstraint] = {
        [
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            popupView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.18),
            popupView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            
            txtName.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            txtName.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            txtName.heightAnchor.constraint(equalToConstant: 40),

            btnConfirm.bottomAnchor.constraint(lessThanOrEqualTo: popupView.bottomAnchor, constant: -20),
            btnConfirm.topAnchor.constraint(greaterThanOrEqualTo: txtName.bottomAnchor, constant: 30),
            btnConfirm.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            btnConfirm.leadingAnchor.constraint(greaterThanOrEqualTo: popupView.leadingAnchor, constant: 60),
            btnConfirm.trailingAnchor.constraint(lessThanOrEqualTo: popupView.trailingAnchor, constant: -60),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45)
        ]
    }()
    
    // MARK: - Initializers
    
    internal init(notebook: NotebookEntity, dismissHandler: (() -> Void)? = nil) {
        self.notebook = notebook
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let notebook = coder.decodeObject(forKey: "notebook") as? NotebookEntity else {
            return nil
        }
        self.init(notebook: notebook, dismissHandler: nil)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        
        view.addSubview(popupView)
        popupView.addSubview(txtName)
        popupView.addSubview(btnConfirm)
        btnConfirm.isEnabled = false

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        selfTapGestureRecognizer.delegate = gestureDelegate
        view.addGestureRecognizer(selfTapGestureRecognizer)
        
        txtName.becomeFirstResponder()
        self.txtName.inputAccessoryView = keyboardToolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - AddNoteObserver functions
    
    /**
     A  method tthat calls btn Confirm Tap.
     */
    func addNote() {
        btnConfirmTap()
    }
    
    // MARK: - IBActions functions

    @IBAction func selfTap() {
        if txtName.isEditing {
            txtName.resignFirstResponder()
        } else {
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
    
    @IBAction func btnConfirmTap() {
        if let text = txtName.text {
            do {
                guard let guardedNotebook = notebook else {
                    return
                }
                let note = try DataManager.shared().createNote(in: guardedNotebook)
                note.title = NSAttributedString(string: text)
                try note.save()
            } catch {
                let alertController = UIAlertController(
                    title: "Error creating a new Note".localized(),
                    message: "The database could not create a new Note".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "A new Note could not be created".localized())
                self.present(alertController, animated: true, completion: nil)
            }
            
            self.dismissHandler?()
            
            self.dismiss(animated: true) { 
                if self.txtName.isEditing {
                    self.txtName.endEditing(true)
                }
            }
        }
    }
    
    // MARK: - Objective-C functions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            centerYConstraint?.constant = -keyboardSize.height*0.5
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        centerYConstraint?.constant = 0
    }
}
