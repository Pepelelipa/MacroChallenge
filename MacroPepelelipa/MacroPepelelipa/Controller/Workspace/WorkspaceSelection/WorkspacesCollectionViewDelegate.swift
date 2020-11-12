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
    internal var viewTraitCollection: UITraitCollection = UITraitCollection()
    internal var frame: CGRect = CGRect()
    
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
        var width: CGFloat = 0
        var height: CGFloat = 0
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        let titleSpace: CGFloat = 20 + 30 + 20 + 20
        
        var isEditing = false
        #warning("Check for macOS Big Sur")
        #if !targetEnvironment(macCatalyst)
        isEditing = collectionView.isEditing
        #endif
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            
            if isEditing {
                // Editing mode
                width = collectionView.bounds.width
                height = 70
                
            } else {
                // Normal mode
                if isLandscape {
                    // Landscape
                    width = collectionView.bounds.width/2.1
                } else {
                    // Portrait
                    width = collectionView.bounds.width
                }
                height = (width * 0.42) + titleSpace
            }
            
        } else {
            // iPad
            
            if isEditing {
                // Editing mode
                
                if frame.width < UIScreen.main.bounds.width/2 {
                    // Multitasking less than half screen
                    width = collectionView.bounds.width
                    height = 70
                } else {
                    // All others
                    width = collectionView.bounds.width/2.1
                    height = 90
                }
                
            } else {
                // Normal mode
                
                if isLandscape {
                    // Landscape
                    
                    if frame.width+5 == UIScreen.main.bounds.width/2 {
                        // Multitasking half screen
                        width = collectionView.bounds.width
                        height = (width * 0.45) + titleSpace
                        
                    } else if frame.width < UIScreen.main.bounds.width/2 {
                        // Multitasking less than half screen
                        width = collectionView.bounds.width
                        height = (width * 0.42) + titleSpace
                        
                    } else {
                        // Full screen and Multitasking more than half screen
                        width = collectionView.bounds.width/2.1
                        height = (width * 0.44) + titleSpace
                    }
                    
                } else {
                    // Portrait
                    
                    if frame.width < UIScreen.main.bounds.width/2 {
                        // Multitasking less than half screen
                        width = collectionView.bounds.width
                        height = (width * 0.42) + titleSpace
                        
                    } else if frame.width == UIScreen.main.bounds.width {
                        // Full screen
                        width = collectionView.bounds.width/2.1
                        height = (width * 0.44) + titleSpace
                    } else {
                        // Multitasking more than half screen
                        width = collectionView.bounds.width
                        height = (width * 0.45) + titleSpace
                    }
                }
            }
        }
        
        return CGSize(width: width, height: height)
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
