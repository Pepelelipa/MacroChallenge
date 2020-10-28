//
//  SearchPageViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import StoreKit

internal enum SearchResultEnum {
    case all
    case notebook
    case workshop
}

internal class SearchResultViewController: UIViewController {

    // MARK: - Variables and Constants
    
    internal weak var filterWorkspaceObserver: FilterWorkspaceObserver?

    private var sharedConstraints: [NSLayoutConstraint] = []
    private weak var ownerViewController: UIViewController?
    
    internal lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        
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
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())
        collectionView.register(
            NotebookCollectionViewCell.self,
            forCellWithReuseIdentifier: NotebookCollectionViewCell.cellID())
        collectionView.register(
            SearchResultCollectionReusableView.self, 
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, 
            withReuseIdentifier: SearchResultCollectionReusableView.cellID())
        
        return collectionView
    }()
    
    private lazy var textViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    private lazy var collectionDelegate = SearchResultCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let workspace = selectedCell.workspace else {
            self.presentErrorAlert(of: .workshop)
            return
        }
        
        let notebooksSelectionView = NotebooksSelectionViewController(workspace: workspace)
        self.ownerViewController?.navigationController?.pushViewController(notebooksSelectionView, animated: true)
        
    } _: { (selectedCell) in
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
                    self.presentErrorAlert(of: .notebook)
                }
            }
            self.presentDestination(for: UIDevice.current.userInterfaceIdiom, 
                                    notebook: notebook)
        } else {
            self.presentErrorAlert(of: .notebook)
        }
    }
    
    private lazy var collectionDataSource = SearchResultCollectionViewDataSource(viewController: ownerViewController, collectionView: {
        self.collectionView })
    
    // MARK: - Init
    
    init(owner: UIViewController? = nil) {
        self.ownerViewController = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Workspaces".localized()
        view.addSubview(collectionView)
        
        setConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: MarkdownHeader.firstHeaderFont,
            .foregroundColor: UIColor.titleColor ?? .black
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .font: MarkdownHeader.thirdHeaderFont,
            .foregroundColor: UIColor.titleColor ?? .black
        ]
        
        self.definesPresentationContext = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    // MARK: - UISearchResultsUpdating Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterWorkspaceObserver?.filterWorkspace(text)
        }
        searchController.showsSearchResultsController = true
        collectionView.reloadData()
    }
    
    // MARK: - Objc Functions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height
            setTextViewConstant(to: -height)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        setTextViewConstant(to: 0)
    }
    
    // MARK: - Functions
    
    private func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        for visibleCell in collectionView.visibleCells {
            if let workspaceCell = visibleCell as? WorkspaceCollectionViewCell {
                workspaceCell.invalidateLayout()
            }
        }
    }
    
    private func setTextViewConstant(to value: CGFloat) {
        textViewBottomConstraint.constant = value
        UIView.animate(withDuration: 0.5) {
            self.collectionView.layoutIfNeeded()
        }
    }
    
    /**
     This private method sets the constraints for different size classes and devices.
     */
    private func setConstraints() {
        sharedConstraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textViewBottomConstraint
        ])
    }
    
    /**
     This method layouts the appropriate constraits based on the current trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
    }
    
    private func presentDestination(for device: UIUserInterfaceIdiom, notebook: NotebookEntity) {
        
        let notesPageViewController = NotesPageViewController(notes: notebook.notes)
        
        if device == .phone {
            self.ownerViewController?.navigationController?.pushViewController(notesPageViewController, animated: true)
        
        } else {
            let destination = TextEditingContainerViewController(centerViewController: notesPageViewController)
            
            self.ownerViewController?.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    private func presentErrorAlert(of type: SearchResultEnum) {
        
        switch type {
        case .notebook:
            let alertController = UIAlertController(
               title: "Could not open this notebook".localized(),
               message: "The app could not load this notebook".localized(),
               preferredStyle: .alert)
               .makeErrorMessage(with: "The notebook collection view cell did not have a notebook".localized())
           
           self.present(alertController, animated: true, completion: nil)
        case .workshop:
            let alertController = UIAlertController(
                title: "Could not open this workspace".localized(),
                message: "The app could not load this workspace".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The workspace cell did not have a workspace".localized())
            
            self.present(alertController, animated: true, completion: nil)
        default:
            return
        }
    }
}
