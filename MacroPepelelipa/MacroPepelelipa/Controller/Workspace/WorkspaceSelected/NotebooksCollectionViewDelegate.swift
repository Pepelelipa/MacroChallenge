//
//  CollectionViewFlowLayoutDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebooksCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var didSelectCell: ((NotebookCollectionViewCell) -> Void)?
    init(_ didSelectCell: @escaping (NotebookCollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                let width = collectionView.bounds.width/5
                return CGSize(width: width, height: width * 1.68)
            } else {
                let width = collectionView.bounds.width/4
                return CGSize(width: width, height: width * 1.67)
            }
        } else {
            if isLandscape {
                let width = collectionView.bounds.width/5.2
                return CGSize(width: width, height: width * 1.74)
            } else {
                let width = collectionView.bounds.width/2.3
                return CGSize(width: width, height: width * 1.72)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? NotebookCollectionViewCell else {
            return
        }
        didSelectCell?(cell)
    }
}
