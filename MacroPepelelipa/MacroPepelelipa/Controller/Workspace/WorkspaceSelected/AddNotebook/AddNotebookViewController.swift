//
//  AddNotebookViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddNotebookViewController: UIViewController {
    
    // MARK: - Variables and Constants

    internal weak var notebook: NotebookEntity?
    
    private var txtNoteDelegate = AddNewSpaceTextFieldDelegate()
    private weak var workspace: WorkspaceEntity?
    private let notebookView = NotebookView(frame: .zero)
    private var referenceView = UIView(frame: .zero)
    
    private var portraitViewConstraints: [NSLayoutConstraint] = []
    private var landscapeViewConstraints: [NSLayoutConstraint] = []
    
    private lazy var keyboardToolBar = AddNewSpaceToolBar(frame: .zero, owner: txtName)
    private lazy var collectionViewDataSource = ColorSelectionCollectionViewDataSource(viewController: self)
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
        txtName.font = MarkdownHeader.thirdHeaderFont
        txtName.tintColor = .actionColor
        txtName.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        txtName.returnKeyType = UIReturnKeyType.done 
        txtName.delegate = txtNoteDelegate

        return txtName
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
        btnConfirm.titleLabel?.font = MarkdownHeader.thirdHeaderFont
        btnConfirm.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return btnConfirm
    }()
    
    private lazy var ratio: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if UIDevice.current.orientation.isActuallyLandscape {
                return UIScreen.main.bounds.width / 2.5
            } else {
                return UIScreen.main.bounds.width / 2
            }
        } else {
            return UIScreen.main.bounds.width - 40
        }
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: ratio),
            
            txtName.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
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
        
        btnConfirm.isEnabled = false
        
        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        selfTapGestureRecognizer.delegate = gestureDelegate
        view.addGestureRecognizer(selfTapGestureRecognizer)
        
        self.txtName.inputAccessoryView = keyboardToolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.setOrientation(.portrait, andRotateTo: .portrait)
        if let notebook = notebook {
            txtName.text = notebook.name
            notebookView.color = UIColor(named: notebook.colorName) ?? .red
            btnConfirm.setTitle("Save notebook".localized(), for: .normal)
            checkBtnEnabled()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.setOrientation(.all)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate(constraints)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Functions

    private func checkBtnEnabled() {
        btnConfirm.isEnabled = txtName.text != ""
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
        guard textField.text != nil else {
            btnConfirm.isEnabled = false
            return
        }
        checkBtnEnabled()
    }

    @IBAction func btnConfirmTap() {
        guard let workspace = workspace, let text = txtName.text,
              let notebookColorName = UIColor.notebookColorName(of: notebookView.color) else {
            let alertController = UIAlertController(
                title: "Error creating new notebook".localized(),
                message: "The app could not retrieve the necessary information".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "Not possible to retrieve a workspace or notebook name in notebook creation".localized())

            present(alertController, animated: true, completion: nil)
            
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
                try notebook.save()
            } else {
                _ = try DataManager.shared().createNotebook(in: workspace, named: text, colorName: notebookColorName)
            }
        } catch {
            let alertController = UIAlertController(
                title: "Error creating the notebook".localized(),
                message: "The database could not create the notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A new Notebook could not be created".localized())
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.dismiss(animated: true) { 
            if self.txtName.isEditing {
                self.txtName.endEditing(true)
            }
        }
    }
}
