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
                                                   SearchBarObserver {
    
    // MARK: - Variables and Constants

    internal var isEmpty: Bool {
        return workspaces.isEmpty
    }
    
    private var filteredWorkspaces = [WorkspaceEntity]()
    private var filteredNotebooks = [NotebookEntity]()
    private var isFiltering: Bool = false
    private var isFilteringWorkspaces: Bool = true
    private var isFilteringNotebooks: Bool = true
    
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
            } else if isFilteringWorkspaces {
                return workspaces.count
            } else {
                return 0
            }
        case 1:
            if isFiltering {
                return filteredNotebooks.count
            } else if isFilteringNotebooks {
                return notebooks.count
            } else {
                return 0
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
                workspaceCell.isEditing = collectionView.isEditing
                return workspaceCell
            } else {
                workspaceCell.setWorkspace(workspaces[indexPath.row], viewController: viewController)
                workspaceCell.isEditing = collectionView.isEditing
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
                if !isFiltering && !workspaces.isEmpty && isFilteringWorkspaces || isFiltering && !filteredWorkspaces.isEmpty {
                    headerView.text = "Workspaces".localized()
                } else {
                    headerView.text = ""
                }
            case 1:
                if !isFiltering && !notebooks.isEmpty && isFilteringNotebooks || isFiltering && !filteredNotebooks.isEmpty {
                    headerView.text = "Notebooks".localized()
                } else {
                    headerView.text = ""
                }
            default:
                headerView.text = ""
            }
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    // MARK: - Internal functions
    
    internal func setFilterWorkspaceObserver() {
        if let workspaceSelectionController = viewController as? WorkspaceSelectionViewController {
            workspaceSelectionController.filterObserver = self
        }
    }
   
    // MARK: - FilterObserver functions
    
    func filterObjects(_ searchText: String, filterCategory: SearchResultEnum?) {
        
        guard let categoryFlag = filterCategory else {
            return
        }
        
        switch categoryFlag {
        case .all:
            filteredWorkspaces = workspaces.filter({ (workspace) -> Bool in
                return workspace.name.lowercased().contains(searchText.lowercased())
            })
            filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
                return notebook.name.lowercased().contains(searchText.lowercased())
            })
            self.isFilteringNotebooks = true
            self.isFilteringWorkspaces = true
        case .workspaces:
            filteredWorkspaces = workspaces.filter({ (workspace) -> Bool in
                return workspace.name.lowercased().contains(searchText.lowercased())
            })
            filteredNotebooks = []
            self.isFilteringNotebooks = false
            self.isFilteringWorkspaces = true
        case .notebook: 
            filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
                return notebook.name.lowercased().contains(searchText.lowercased())
            })
            filteredWorkspaces = []
            self.isFilteringNotebooks = true
            self.isFilteringWorkspaces = false
        }
    }
    
    func isFiltering(_ value: Bool) {
        isFiltering = value
    }
}
