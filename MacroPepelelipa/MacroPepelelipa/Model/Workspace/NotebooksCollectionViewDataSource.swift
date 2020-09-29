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
    internal init(workspace: WorkspaceEntity) {
        self.workspace = workspace
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workspace?.notebooks.count ?? 0
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NotebookCollectionViewCell.cellID, for: indexPath)
                as? NotebookCollectionViewCell,
                let notebook = workspace?.notebooks[indexPath.row] else {
                fatalError("Sorry not sorry")
        }
        cell.setNotebook(notebook)
        return cell
    }
}
