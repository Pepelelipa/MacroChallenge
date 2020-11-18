//
//  ItemSizeHelper.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct ItemSizeHelper {
    
    /**
     This method sets the size for workspace items at a collectionView.
     - Parameter collectionView: the presented collectionView.
     - Parameter frame: the current frame of the viewController.
     - Returns the size for the collectionView items.
     */
    static internal func workspaceItemSize(at collectionView: UICollectionView, for frame: CGRect) -> CGSize {
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        let width: CGFloat
        let height: CGFloat
        
        let titleSpace: CGFloat = 20 + 30 + 20 + 20
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            
            if collectionView.isEditing {
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
    
    /**
     This method sets the size for notebooks items at a collectionView.
     - Parameter collectionView: the presented collectionView.
     - Parameter frame: the current frame of the viewController.
     - Returns the size for the collectionView items.
     */
    static internal func notebookItemSize(at collectionView: UICollectionView, for frame: CGRect) -> CGSize {
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        let width: CGFloat
        let height: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .phone {
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
            
        } else {
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
        }
        return CGSize(width: width, height: height)
    }
}
