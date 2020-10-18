//
//  ColorSelectionCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class ColorSelectionCollectionViewDelegate: NSObject, 
                                                     UICollectionViewDelegate, 
                                                     UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables and Constants

    private var selectionHandler: ((ColorSelectionCollectionViewCell) -> Void)?
    
    // MARK: - Initializers
    
    internal init(selectionHandler: ((ColorSelectionCollectionViewCell) -> Void)? = nil) {
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Functions

    func getWidth(from frame: CGRect) -> CGFloat {
        return frame.height/4.65
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorSelectionCollectionViewCell {
            selectionHandler?(cell)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = getWidth(from: collectionView.bounds)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let count = CGFloat(UIColor.notebookColors.count)/3

        let totalCellWidth = getWidth(from: collectionView.frame) * count
        let totalSpacingWidth = 10 * (count - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
