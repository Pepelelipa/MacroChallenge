//
//  AddNotebookViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddNotebookViewController: ViewController {
    
    // MARK: - Variables and Constants

    internal weak var notebook: NotebookEntity?
    
    private var txtNoteDelegate = AddNewSpaceTextFieldDelegate()
    private weak var workspace: WorkspaceEntity?
    private let notebookView = NotebookView(frame: .zero)
    private var referenceView = UIView(frame: .zero)
    
    private var popupViewViewConstraints: [NSLayoutConstraint] = []
    
    private lazy var keyboardToolBar = AddNewSpaceToolBar(frame: .zero, owner: txtName)
    private lazy var collectionViewDataSource = ColorSelectionCollectionViewDataSource()
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
        txtName.placeholder = "New notebook name".localized()
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
        button.accessibilityHint = "Dismiss notebook pop-up hint".localized()
        return button
    }()
    
    private lazy var collectionViewDelegate = ColorSelectionCollectionViewDelegate {
        self.notebookView.color = $0.color ?? .clear
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentMode = .center
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.isUserInteractionEnabled = true

        collectionView.register(ColorSelectionCollectionViewCell.self, forCellWithReuseIdentifier: ColorSelectionCollectionViewCell.cellID())

        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate

        return collectionView
    }()

    private lazy var btnConfirm: UIButton = {
        let btnConfirm = UIButton()
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.setTitle("Create new notebook".localized(), for: .normal)
        btnConfirm.titleLabel?.adjustsFontSizeToFitWidth = true
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.tintColor = .white
        btnConfirm.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        btnConfirm.layer.cornerRadius = 22
        btnConfirm.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3)
        btnConfirm.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return btnConfirm
    }()
    
    private var ratio: CGFloat {
        if UIDevice.current.userInterfaceIdiom != .phone {
            if UIDevice.current.orientation.isActuallyLandscape {
                if view.frame.width > UIScreen.main.bounds.width/2 {
                    return view.frame.width / 2
                }
            } else {
                if view.frame.width == UIScreen.main.bounds.width {
                    return view.frame.width / 2
                }
            }
        } 
        return view.frame.width - 40
    }
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            dismissButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.06),
            dismissButton.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.06),
            
            txtName.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 5),
            txtName.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            txtName.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            txtName.heightAnchor.constraint(equalToConstant: 45),
            
            notebookView.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: 30),
            notebookView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            notebookView.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.3),
            notebookView.widthAnchor.constraint(equalTo: notebookView.heightAnchor, multiplier: 0.75),
            
            collectionView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: btnConfirm.topAnchor, constant: -40),
            collectionView.widthAnchor.constraint(equalTo: popupView.widthAnchor, constant: -40),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.3382352941),

            btnConfirm.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
            btnConfirm.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            btnConfirm.leadingAnchor.constraint(greaterThanOrEqualTo: popupView.leadingAnchor, constant: 60),
            btnConfirm.trailingAnchor.constraint(lessThanOrEqualTo: popupView.trailingAnchor, constant: -60),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45)
        ]
    }()
    
    // MARK: - Initializers
    
    internal init(workspace: WorkspaceEntity?) {
        self.workspace = workspace
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let workspace = coder.decodeObject(forKey: "workspace") as? WorkspaceEntity else {
            return nil
        }
        self.init(workspace: workspace)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UIColor.randomNotebookColor() {
            notebookView.color = color
        }
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        
        view.addSubview(popupView)
        popupView.addSubview(txtName)
        popupView.addSubview(collectionView)
        popupView.addSubview(notebookView)
        popupView.addSubview(btnConfirm)
        popupView.addSubview(dismissButton)
        
        btnConfirm.isEnabled = false
        
        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        selfTapGestureRecognizer.delegate = gestureDelegate
        view.addGestureRecognizer(selfTapGestureRecognizer)
        
        self.txtName.inputAccessoryView = keyboardToolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtName.becomeFirstResponder()
        AppUtility.setOrientation(.portrait, andRotateTo: .portrait)
        if let notebook = notebook {
            txtName.text = notebook.name
            notebookView.color = UIColor(named: notebook.colorName) ?? .red
            btnConfirm.setTitle("Save Notebook".localized(), for: .normal)
            checkBtnEnabled()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.setOrientation(.all)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate(constraints)
        
        NSLayoutConstraint.deactivate(popupViewViewConstraints)
        popupViewViewConstraints.removeAll()
        
        popupViewViewConstraints.append(popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        popupViewViewConstraints.append(popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        popupViewViewConstraints.append(popupView.widthAnchor.constraint(equalToConstant: ratio))
        NSLayoutConstraint.activate(popupViewViewConstraints)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Functions

    private func checkBtnEnabled() {
        btnConfirm.isEnabled = txtName.text != ""
    }

    // MARK: - IBActions functions
    
    @IBAction func dismissPopUpView() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        guard textField.text != nil else {
            btnConfirm.isEnabled = false
            return
        }
        checkBtnEnabled()
    }

    @IBAction func btnConfirmTap() {
        guard let workspace = workspace, let text = txtName.text,
              let notebookColorName = UIColor.notebookColorName(of: notebookView.color) else {
            
            let title = "Error creating new notebook".localized()
            let message = "Not possible to retrieve a workspace or notebook name in notebook creation".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            self.dismiss(animated: true) { 
                if self.txtName.isEditing {
                    self.txtName.endEditing(true)
                }
            }
            return
        }
        do {
            if let notebook = notebook {
                notebook.name = text
                notebook.colorName = notebookColorName
            } else {
                _ = try DataManager.shared().createNotebook(in: workspace, named: text, colorName: notebookColorName)
            }
        } catch {
            
            let title = "Error creating the notebook".localized()
            let message = "A new Notebook could not be created".localized()
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
        
        self.dismiss(animated: true) { 
            if self.txtName.isEditing {
                self.txtName.endEditing(true)
            }
        }
    }
}
