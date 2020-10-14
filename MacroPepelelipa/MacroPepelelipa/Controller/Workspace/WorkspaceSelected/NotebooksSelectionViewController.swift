//
//  NotebooksCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksSelectionViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    private var collectionDataSource: NotebooksCollectionViewDataSource?
    internal private(set) weak var workspace: WorkspaceEntity?

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource

        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID())

        return collectionView
    }()

    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        return item
    }()
    
    private lazy var collectionDelegate = NotebooksCollectionViewDelegate { [unowned self] (selectedCell) in
        if let notebook = selectedCell.notebook {
            let note: NoteEntity
            if let lastNote = notebook.notes.last {
                note = lastNote
            } else {
                do {
                    note = try DataManager.shared().createNote(in: notebook)
                    note.title = NSAttributedString(string: "Lesson".localized())
                    try note.save()
                } catch {
                    self.presentErrorAlert()
                }
            }
            
            self.presentDestination(for: UIDevice.current.userInterfaceIdiom, 
                                    notebook: notebook)
            
        } else {
            self.presentErrorAlert()
        }
    }
    
    // MARK: - Initializers
    
    internal init(workspace: WorkspaceEntity) {
        super.init(nibName: nil, bundle: nil)
        self.workspace = workspace
        self.collectionDataSource = NotebooksCollectionViewDataSource(workspace: workspace, viewController: self, collectionView: { self.collectionView })
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
        navigationItem.rightBarButtonItem = btnAdd
        navigationItem.title = workspace?.name
        view.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Funtions
    
    private func presentErrorAlert() {
        
         let alertController = UIAlertController(
            title: "Could not open this notebook".localized(),
            message: "The app could not load this notebook".localized(),
            preferredStyle: .alert)
            .makeErrorMessage(with: "The notebook collection view cell did not have a notebook".localized())
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentDestination(for device: UIUserInterfaceIdiom, notebook: NotebookEntity) {
        
        let notesViewController = NotesViewController(notebook: notebook, 
                                              note: notebook.notes[notebook.notes.count-1])
        
        if device == .phone {
            self.navigationController?.pushViewController(notesViewController, animated: true)
        
        } else {
            let destination = TextEditingContainerViewController(centerViewController: notesViewController)
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func btnAddTap() {
        btnAdd.isEnabled = false
        navigationItem.hidesBackButton = true
        AppUtility.setOrientation(.portrait, andRotateTo: .portrait)
        let addController = AddNotebookViewController(workspace: workspace, dismissHandler: {
            self.btnAdd.isEnabled = true
            self.navigationItem.hidesBackButton = false
            AppUtility.setOrientation(.all)
        })
        addController.moveTo(self)
    }
}
