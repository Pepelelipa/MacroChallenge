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

    func getSize(from frame: CGRect) -> CGFloat {
        let frameOccupiedByCell = frame.width * 0.0735
        return frameOccupiedByCell
    }
    
    func getInsets(from frame: CGRect) -> CGFloat {
        let frameOccupiedByInset = frame.width * 0.058
        return frameOccupiedByInset
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorSelectionCollectionViewCell {
            selectionHandler?(cell)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = getSize(from: collectionView.bounds)
        let height = getSize(from: collectionView.bounds)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return getInsets(from: collectionView.bounds)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return getInsets(from: collectionView.bounds)
    }
}
