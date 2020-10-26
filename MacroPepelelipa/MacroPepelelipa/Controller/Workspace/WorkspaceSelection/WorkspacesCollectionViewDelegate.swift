//
//  WorkspaceCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspacesCollectionViewDelegate: NSObject,
                                                 UICollectionViewDelegate,
                                                 UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables and Constants
    
    private var didSelectCell: ((WorkspaceCollectionViewCell) -> Void)?
    
    // MARK: - Initializers
    
    internal init(_ didSelectCell: @escaping (WorkspaceCollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell else {
            return
        }
        didSelectCell?(cell)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                width = collectionView.bounds.width/2 - 25
                height = width/1.6
            } else {
                width = collectionView.bounds.width/2.1
                height = width/1.5
            }
        } else {
            if isLandscape {
                width = collectionView.bounds.width/2.1
                height = width/1.45
            } else {
                width = collectionView.bounds.width
                height = width/1.45
            }
        }
        return CGSize(width: width, height: collectionView.isEditing ? 70 : height)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 50
        }
        return 20
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
