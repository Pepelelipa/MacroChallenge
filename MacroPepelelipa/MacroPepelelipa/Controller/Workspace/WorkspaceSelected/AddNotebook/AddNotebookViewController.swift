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
    private lazy var keyboardToolBar = AddNotebookToolBar(frame: .zero, owner: txtName)
    private var txtNoteDelegate = AddNotebookTextFieldDelegate()

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
        txtName.returnKeyType = UIReturnKeyType.done 
        txtName.delegate = txtNoteDelegate

        return txtName
    }()

    private let notebookView = NotebookView(frame: .zero)

    private lazy var collectionViewDataSource = ColorSelectionCollectionViewDataSource(viewController: self)
    private lazy var collectionViewDelegate = ColorSelectionCollectionViewDelegate {
        self.notebookView.color = $0.color ?? .clear
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

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
        btnConfirm.addTarget(self, action: #selector(btnConfirmTap), for: .touchUpInside)
        btnConfirm.tintColor = .white
        btnConfirm.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        btnConfirm.layer.cornerRadius = 22

        return btnConfirm
    }()

    var portraitViewConstraints: [NSLayoutConstraint] = []
    var landscapeViewConstraints: [NSLayoutConstraint] = []
    override func moveTo(_ viewController: UIViewController) {
        super.moveTo(viewController)
        portraitViewConstraints = [
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.6),
            view.widthAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.7),
            view.widthAnchor.constraint(lessThanOrEqualTo: viewController.view.widthAnchor, multiplier: 0.95)
        ]
        landscapeViewConstraints = [
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.7),
            view.widthAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 1.4),
            view.widthAnchor.constraint(lessThanOrEqualTo: viewController.view.widthAnchor, multiplier: 0.8)
        ]
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(landscapeViewConstraints)
        } else {
            NSLayoutConstraint.activate(portraitViewConstraints)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = UIColor.randomNotebookColor() {
            notebookView.color = color
        }
        view.addSubview(txtName)
        view.addSubview(collectionView)
        view.addSubview(notebookView)
        view.addSubview(btnConfirm)
        btnConfirm.isEnabled = false

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        selfTapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(selfTapGestureRecognizer)
        self.txtName.inputAccessoryView = keyboardToolBar
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(portraitViewConstraints)
            NSLayoutConstraint.activate(landscapeViewConstraints)
        } else {
            NSLayoutConstraint.deactivate(landscapeViewConstraints)
            NSLayoutConstraint.activate(portraitViewConstraints)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            txtName.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            txtName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            txtName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            txtName.heightAnchor.constraint(equalToConstant: 45),
            txtName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            notebookView.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: 30),
            notebookView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notebookView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            notebookView.widthAnchor.constraint(equalTo: notebookView.heightAnchor, multiplier: 0.75)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: 30),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            collectionView.widthAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 2.4),
            collectionView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            btnConfirm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
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
        guard let workspace = workspace, let text = txtName.text,
              let notebookColorName = UIColor.notebookColorName(of: notebookView.color) else {
            let alertController = UIAlertController(
                title: "Error creating new notebook".localized(),
                message: "The app could not retrieve the necessary information".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "Not possible to retrieve a workspace or notebook name in notebook creation".localized())

            present(alertController, animated: true, completion: nil)
            dismissFromParent()
            return
        }
        _ = Mockdata.createNotebook(on: workspace, named: text, colorName: notebookColorName)
        dismissFromParent()
    }

    override func backgroundTap() {
        if txtName.isEditing {
            txtName.endEditing(true)
        } else {
            super.backgroundTap()
        }
    }
}
