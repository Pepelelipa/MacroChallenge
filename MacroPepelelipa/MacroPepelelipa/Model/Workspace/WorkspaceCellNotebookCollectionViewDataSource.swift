//
//  WorkspaceCellCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspaceCellNotebookCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Variables and Constants

    private weak var workspace: WorkspaceEntity?
    private weak var viewController: UIViewController?
    
    // MARK: - Initializers

    internal init(workspace: WorkspaceEntity, viewController: UIViewController? = nil) {
        self.workspace = workspace
        self.viewController = viewController
    }
    
    // MARK: - UICollectionViewDataSource functions

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if workspace?.notebooks.count ?? 0 < 5 {
            return 5
        } else {
            return 8
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WorkspaceCellNotebookCollectionViewCell.cellID(), for: indexPath)
                as? WorkspaceCellNotebookCollectionViewCell else {
            let alertController = UIAlertController(
                title: "Error presenting a notebook".localized(),
                message: "The app could not present a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook cell could not be loaded in a workspace".localized())
            
            viewController?.present(alertController, animated: true, completion: nil)
            return UICollectionViewCell()
        }
        cell.isHidden = false

        if indexPath.row == 7 || (indexPath.row == 4 && (workspace?.notebooks.count ?? 5 < 5)) {
            cell.isHidden = true
        } else if indexPath.row < workspace?.notebooks.count ?? 0,
           let colorName = workspace?.notebooks[indexPath.row].colorName {
            cell.color = UIColor(named: colorName) ?? .clear
        } else {
            let randomColor = UIColor.gray.withAlphaComponent(0.15)
            cell.color = randomColor
        }
        return cell
    }
}
