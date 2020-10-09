//
//  WorkspacesCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspacesCollectionViewDataSource: NSObject, UICollectionViewDataSource, EntityObserver {

    func entityWasCreated(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity {
            workspace.addObserver(self)
            workspaces.append(workspace)
            self.collectionView?().insertItems(at: [IndexPath(item: workspaces.count - 1, section: 0)])
        }
    }
    func entityDidChangeTo(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity,
           let index = workspaces.firstIndex(where: { $0 === workspace }) {
            self.collectionView?().reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    func entityWasDeleted(_ value: ObservableEntity) {
        if let workspace = value as? WorkspaceEntity,
           let index = workspaces.firstIndex(where: { $0 === workspace }) {
            workspaces.remove(at: index)
            self.collectionView?().deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private weak var viewController: UIViewController?
    private let collectionView: (() -> UICollectionView)?
    
    init(viewController: UIViewController? = nil, collectionView: (() -> UICollectionView)?) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()

        DataManager.shared().addCreationObserver(self, type: .workspace)
    }
    
    private var workspaces: [WorkspaceEntity] = {
        do {
            let workspaces = try Database.DataManager.shared().fetchWorkspaces()
            return workspaces
        } catch {
            fatalError("Failed to fetch")
        }
    }()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workspaces.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.setWorkspace(workspaces[indexPath.row], viewController: viewController)
        return cell
    }
}
