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
    internal private(set) weak var workspace: WorkspaceEntity?
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
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource
        
        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID())
        
        return collectionView
    }()
    private var collectionDataSource: NotebooksCollectionViewDataSource?
    private lazy var collectionDelegate = NotebooksCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let notebook = selectedCell.notebook else {
            let alertController = UIAlertController(
                title: "Could not open this notebook".localized(),
                message: "The app could not load this notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The notebook collection view cell did not have a notebook".localized())
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let split = SplitViewController(notebook: notebook)
        
        #warning("Fade animation as placeholder for Books animation.")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(split, animated: false)
    }
    
    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        return item
    }()
    @IBAction func btnAddTap() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = btnAdd
        navigationItem.title = workspace?.name
        view.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @IBAction func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let cell = collectionView.cellForItem(at: indexPath) as? NotebookCollectionViewCell,
              let notebook = cell.notebook else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .notebook, deletionHandler: { _ in
            do {
                _ = try DataManager.shared().deleteNotebook(notebook)
            } catch {
                let alertController = UIAlertController(
                    title: "Could not delete this notebook".localized(),
                    message: "The app could not delete the notebook".localized() + notebook.name,
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
}
