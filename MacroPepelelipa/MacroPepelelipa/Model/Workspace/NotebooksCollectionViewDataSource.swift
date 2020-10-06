//
//  WorkspaceCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var workspace: WorkspaceEntity?
    private weak var viewController: UIViewController?
    
    internal init(workspace: WorkspaceEntity, viewController: UIViewController?) {
        self.workspace = workspace
        self.viewController = viewController
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workspace?.notebooks.count ?? 0
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NotebookCollectionViewCell.cellID(), for: indexPath)
                as? NotebookCollectionViewCell,
                let notebook = workspace?.notebooks[indexPath.row] else {
            let alertController = UIAlertController(
                title: "Error presenting a notebook".localized(),
                message: "The app could not present a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook cell could not be loaded in a workspace".localized())
            
            viewController?.present(alertController, animated: true, completion: nil)    
            return UICollectionViewCell()
        }
        cell.setNotebook(notebook)
        return cell
    }
}
