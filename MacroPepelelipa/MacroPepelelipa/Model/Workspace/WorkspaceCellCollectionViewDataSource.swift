//
//  WorkspaceCellCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspaceCellCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    private weak var workspace: WorkspaceEntity?

    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workspace?.notebooks.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WorkspaceCellNotebookCollectionViewCell.cellID, for: indexPath)
                as? WorkspaceCellNotebookCollectionViewCell else {
            fatalError("Sorry not sorry")
        }
        return cell
    }
}
