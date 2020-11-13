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
    internal var numberOfFilteredWorkspaces: Int?
    internal var numberOfFilteredNotebooks: Int?
    
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
        var size = CGSize()
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
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
            if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
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
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac  {
            return 50
        }
        return 20
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 0, bottom: 20, right: 0)
    }
}
