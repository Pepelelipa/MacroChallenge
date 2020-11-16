//
//  SearchResultCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class SearchResultCollectionViewDelegate: NSObject,
                                                 UICollectionViewDelegate,
                                                 UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables and Constants
    
    private var didSelectCell: ((UICollectionViewCell) -> Void)?
    internal var frame: CGRect = CGRect()
    
    // MARK: - Initializers
    
    internal init(_ didSelectCell: @escaping (UICollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        if let cell = collectionView.cellForItem(at: indexPath) {
            didSelectCell?(cell)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return ItemSizeHelper.workspaceItemSize(at: collectionView, for: frame)
        } else if indexPath.section == 1 {
            return ItemSizeHelper.notebookItemSize(at: collectionView, for: frame)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            return 50
        }
        return 20
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 0, bottom: 20, right: 0)
    }
}
