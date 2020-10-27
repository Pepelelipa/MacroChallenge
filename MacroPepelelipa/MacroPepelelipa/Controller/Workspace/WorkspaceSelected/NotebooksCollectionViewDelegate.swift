//
//  CollectionViewFlowLayoutDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebooksCollectionViewDelegate: NSObject, 
                                                UICollectionViewDelegate, 
                                                UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables and Constants
    
    private var didSelectCell: ((NotebookCollectionViewCell) -> Void)?
    
    // MARK: - Initializers
    
    internal init(_ didSelectCell: @escaping (NotebookCollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? NotebookCollectionViewCell else {
            return
        }
        didSelectCell?(cell)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        let width: CGFloat
        let height: CGFloat

        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                width = collectionView.bounds.width/5
                height = width * 1.68
            } else {
                width = collectionView.bounds.width/4
                height = width * 1.67
            }
        } else {
            if collectionView.isEditing {
                width = collectionView.bounds.width
                height = 70
            } else if isLandscape {
                width = collectionView.bounds.width/5.2
                height = width * 1.74
            } else {
                width = collectionView.bounds.width/2.3
                height = width * 1.72
            }
        }

        return CGSize(width: width, height: collectionView.isEditing ? 70 : height)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
