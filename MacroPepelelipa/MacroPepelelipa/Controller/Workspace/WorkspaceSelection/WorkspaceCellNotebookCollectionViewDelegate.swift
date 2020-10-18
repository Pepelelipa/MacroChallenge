//
//  WorkspaceCellNotebookCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 30/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceCellNotebookCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables and Constants

    private let totalNotebooks: Int
    
    // MARK: - Initializers
    
    internal init(totalNotebooks: Int) {
        self.totalNotebooks = totalNotebooks
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || (totalNotebooks < 5 && indexPath.row == 1) {
            return CGSize(width: collectionView.bounds.width/2.7, height: collectionView.bounds.height)
        }
        return CGSize(width: collectionView.bounds.width/5.7, height: collectionView.bounds.height/2.3)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
