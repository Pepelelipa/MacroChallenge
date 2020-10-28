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
    
    private var didSelectWorkspaceCell: ((WorkspaceCollectionViewCell) -> Void)?
    private var didSelectNotebookCell: ((NotebookCollectionViewCell) -> Void)?
    internal var numberOfFilteredWorkspaces: Int?
    internal var numberOfFilteredNotebooks: Int?
    
    // MARK: - Initializers
    
    internal init(_ didSelectWorkspaceCell: @escaping (WorkspaceCollectionViewCell) -> Void, _ didSelectNotebookCell: @escaping (NotebookCollectionViewCell) -> Void) {
        self.didSelectWorkspaceCell = didSelectWorkspaceCell
        self.didSelectNotebookCell = didSelectNotebookCell
    }
    
    // MARK: - UICollectionViewDelegate functions
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        if let workspaceCell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell {
            didSelectWorkspaceCell?(workspaceCell)
        }
        
        if let notebookCell = collectionView.cellForItem(at: indexPath) as? NotebookCollectionViewCell {
            didSelectNotebookCell?(notebookCell)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout functions

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if isLandscape {
                    let width = collectionView.bounds.width/2 - 25
                    size = CGSize(width: width, height: width/1.6)
                } else {
                    let width = collectionView.bounds.width/2.1
                    size = CGSize(width: width, height: width/1.5)
                }
            } else {
                if isLandscape {
                    let width = collectionView.bounds.width/2.1
                    size = CGSize(width: width, height: width/1.45)
                } else {
                    let width = collectionView.bounds.width
                    size = CGSize(width: width, height: width/1.45)
                }
            }
        } else if indexPath.section == 1 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if isLandscape {
                    let width = collectionView.bounds.width/5
                    size = CGSize(width: width, height: width * 1.68)
                } else {
                    let width = collectionView.bounds.width/4
                    size = CGSize(width: width, height: width * 1.67)
                }
            } else {
                if isLandscape {
                    let width = collectionView.bounds.width/5.2
                    size = CGSize(width: width, height: width * 1.74)
                } else {
                    let width = collectionView.bounds.width/2.3
                    size = CGSize(width: width, height: width * 1.72)
                }
            }
        }
        return size
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
