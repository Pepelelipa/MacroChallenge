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

    private weak var workspace: WorkspaceEntity?

    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if workspace?.notebooks.count ?? 0 < 5 {
            return 5
        } else {
            return 8
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WorkspaceCellNotebookCollectionViewCell.cellID, for: indexPath)
                as? WorkspaceCellNotebookCollectionViewCell else {
            fatalError("Sorry not sorry")
        }
        if indexPath.row < workspace?.notebooks.count ?? 0,
           let color = workspace?.notebooks[indexPath.row].color {
            cell.color = UIColor(cgColor: color)
        } else if indexPath.row == 7 || (indexPath.row == 4 && (workspace?.notebooks.count ?? 5 < 5)) {
            cell.isHidden = true
        } else {
            cell.color = .random(alpha: 0.3)
        }
        return cell
    }
}
