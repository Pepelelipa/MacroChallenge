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
    internal var frame: CGRect = CGRect()
    
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
            // iPad
            
            if collectionView.isEditing {
                // Editing mode
                
                if frame.width == UIScreen.main.bounds.width {
                    // Full screen
                    width = collectionView.bounds.width/2.1
                    height = 90
                } else {
                    // All others
                    width = collectionView.bounds.width
                    height = 70
                }
            
            } else {
                // Normal mode
                
                if isLandscape {
                    // Landscape
                    
                    if frame.width+5 == UIScreen.main.bounds.width/2 {
                        // Multitasking half screen
                        width = collectionView.bounds.width/4
                        height = width * 2.0
                        
                    } else if frame.width < UIScreen.main.bounds.width/2 {
                        // Multitasking less than half screen
                        width = collectionView.bounds.width/2.5
                        height = width * 2.0
                        
                    } else if frame.width == UIScreen.main.bounds.width {
                        // Full screen
                        width = collectionView.bounds.width/6
                        height = width * 1.85
                        
                    } else {
                        // Multitasking more than half screen
                        width = collectionView.bounds.width/5
                        height = width * 1.85
                    }
                    
                } else {
                    // Portrait
                    
                    if frame.width < UIScreen.main.bounds.width/2 {
                        // Multitasking less than half screen
                        width = collectionView.bounds.width/1.5
                    
                    } else if frame.width == UIScreen.main.bounds.width {
                        // Full screen
                        width = collectionView.bounds.width/4
                    } else {
                        // Multitasking more than half screen
                        width = collectionView.bounds.width/2.5
                    }
                    height = width * 1.8
                }
            }
            
        } else {
            // iPhone
            
            if collectionView.isEditing {
                // Editing mode
                width = collectionView.bounds.width
                height = 70
                
            } else {
                // Normal mode
                if isLandscape {
                    // Landscape
                    width = collectionView.bounds.width/5.2
                    height = width * 1.74
                } else {
                    // Portrait
                    width = collectionView.bounds.width/2.3
                    height = width * 1.72
                }
            }
        }
        return CGSize(width: width, height: height)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
