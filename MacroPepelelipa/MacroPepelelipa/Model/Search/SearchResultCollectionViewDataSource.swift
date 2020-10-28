//
//  SearchResultCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class SearchResultCollectionViewDataSource: NSObject, 
                                                   UICollectionViewDataSource,
                                                   FilterWorkspaceObserver {
    
    // MARK: - Variables and Constants

    internal var isEmpty: Bool {
        return workspaces.isEmpty
    }
    
    private var filteredWorkspaces = [WorkspaceEntity]()
    private var filteredNotebooks = [NotebookEntity]()
    private var isFiltering: Bool = false
    
    private let collectionView: (() -> UICollectionView)?
    
    private weak var viewController: UIViewController?
    
    private lazy var workspaces: [WorkspaceEntity] = {
        do {
            let workspaces = try Database.DataManager.shared().fetchWorkspaces()
            return workspaces
        } catch {
            let alertController = UIAlertController(
                title: "Error fetching the workspaces".localized(),
                message: "The database could not fetch the workspace".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The Workspaces could not be fetched".localized())
            if let viewController = viewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
            return []
        }
    }()
    
    private lazy var notebooks: [NotebookEntity] = {
        var notebooksArray = [NotebookEntity]()
        
        self.workspaces.forEach { (workspace) in
            notebooksArray.append(contentsOf: workspace.notebooks)
        }
        return notebooksArray
    }()

    // MARK: - Initializers
    
    internal init(viewController: UIViewController? = nil, collectionView: (() -> UICollectionView)?) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        setFilterWorkspaceObserver()
    }
    
    // MARK: - UICollectionViewDataSource functions
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if isFiltering {
                return filteredWorkspaces.count
            } else {
                return workspaces.count
            }
        case 1:
            if isFiltering {
                return filteredNotebooks.count
            } else {
                return notebooks.count
            }
        default:
            return 0
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let workspaceCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WorkspaceCollectionViewCell.cellID(), for: indexPath)
                    as? WorkspaceCollectionViewCell else {
                let alertController = UIAlertController(
                    title: "Error presenting a workspace".localized(),
                    message: "The app could not present a workspace".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "A workspace cell could not be loaded".localized())
                
                viewController?.present(alertController, animated: true, completion: nil)
                return UICollectionViewCell()
            }
                        
            if isFiltering {
                workspaceCell.setWorkspace(filteredWorkspaces[indexPath.row], viewController: viewController)
                return workspaceCell
            } else {
                workspaceCell.setWorkspace(workspaces[indexPath.row], viewController: viewController)
                return workspaceCell
            } 
        case 1:
            
            guard let notebookCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NotebookCollectionViewCell.cellID(), for: indexPath)
                    as? NotebookCollectionViewCell else {
                let alertController = UIAlertController(
                    title: "Error presenting a notebook".localized(),
                    message: "The app could not present a notebook".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "A notebook cell could not be loaded in a workspace".localized())
                
                viewController?.present(alertController, animated: true, completion: nil)    
                return UICollectionViewCell()
            }
            
            notebookCell.backgroundColor = .clear
            
            if isFiltering {
                notebookCell.setNotebook(filteredNotebooks[indexPath.row])
                return notebookCell
            } else {
                notebookCell.setNotebook(notebooks[indexPath.row])
                return notebookCell
            } 
        default:
            return UICollectionViewCell(frame: .zero)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: SearchResultCollectionReusableView.cellID(), 
                                                                                   for: indexPath) as? SearchResultCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case 0:
                headerView.text = "Workspaces".localized()
            case 1:
                headerView.text = "Notebooks".localized()
            default:
                headerView.text = ""
            }
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: - Internal functions
    
    internal func setFilterWorkspaceObserver() {
        if let workspaceSelectionController = viewController as? WorkspaceSelectionViewController {
            workspaceSelectionController.filterWorkspaceObserver = self
        }
    }
   
    // MARK: - FilterWorkspaceObserver functions
    
    func filterWorkspace(_ searchText: String) {
        
        filteredWorkspaces = workspaces.filter({ (workspace) -> Bool in
            return workspace.name.lowercased().contains(searchText.lowercased())
        })
        filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
            return notebook.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func isFiltering(_ value: Bool) {
        isFiltering = value
    }
}
