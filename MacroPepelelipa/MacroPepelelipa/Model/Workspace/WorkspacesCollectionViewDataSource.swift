//
//  WorkspacesCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspacesCollectionViewDataSource: NSObject, 
                                                   UICollectionViewDataSource, 
                                                   EntityObserver,
                                                   FilterWorkspaceObserver {
    
    // MARK: - Variables and Constants

    internal var isEmpty: Bool {
        return workspaces.isEmpty
    }
    
    private var filteredWorkspaces = [WorkspaceEntity]()
    private var isFiltering: Bool = false
    private let collectionView: (() -> UICollectionView)?
    private weak var viewController: UIViewController?
    
    internal lazy var workspaces: [WorkspaceEntity] = {
        do {
            let workspaces = try Database.DataManager.shared().fetchWorkspaces()
            for workspace in workspaces {
                workspace.addObserver(self)
            }
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
    
    // MARK: - Initializers
    
    internal init(viewController: UIViewController? = nil, collectionView: (() -> UICollectionView)?) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        setFilterWorkspaceObserver()
        DataManager.shared().addCreationObserver(self, type: .workspace)
    }
    
    // MARK: - UICollectionViewDataSource functions
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewController = viewController as? WorkspaceSelectionViewController {
            if workspaces.isEmpty {
                viewController.switchEmptyScreenView()
            } else {
                viewController.switchEmptyScreenView(shouldBeHidden: true)
            }
        }
        
        if isFiltering {
            return filteredWorkspaces.count
        } else {
            return workspaces.count
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
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
            cell.setWorkspace(filteredWorkspaces[indexPath.row], viewController: viewController)
        } else {
            cell.setWorkspace(workspaces[indexPath.row], viewController: viewController)
        } 
        return cell
    }
    
    // MARK: - EntityObserver functions
    
    internal func entityWasCreated(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity {
            workspace.addObserver(self)
            workspaces.append(workspace)
            self.collectionView?().insertItems(at: [IndexPath(item: workspaces.count - 1, section: 0)])
        }
    }
    
    internal func entityDidChangeTo(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity,
           let index = workspaces.firstIndex(where: { $0 === workspace }) {
            self.collectionView?().reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    internal func entityShouldDelete(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity,
           let index = workspaces.firstIndex(where: { $0 === workspace }) {
            workspace.removeObserver(self)
            workspaces.remove(at: index)
            self.collectionView?().deleteItems(at: [IndexPath(item: index, section: 0)])
        }

        guard let viewController = viewController as? WorkspaceSelectionViewController else {
            return
        }
        if workspaces.isEmpty {
            viewController.switchEmptyScreenView()
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
    }
    
    func isFiltering(_ value: Bool) {
        isFiltering = value
    }
    
}
