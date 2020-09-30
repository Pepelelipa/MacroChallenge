//
//  WorkspaceCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspaceCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var didSelectCell: ((WorkspaceCollectionViewCell) -> Void)?
    init(_ didSelectCell: @escaping (WorkspaceCollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize
        let isLandscape = UIDevice.current.orientation.isLandscape
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                size = CGSize(width: collectionView.bounds.width/2.1, height: collectionView.bounds.height/2)
            } else {
                size = CGSize(width: collectionView.bounds.width/2.1, height: collectionView.bounds.height/3.5)
            }
        } else {
            if isLandscape {
                size = CGSize(width: collectionView.bounds.width/2.1, height: collectionView.bounds.height/1.5)
            } else {
                size = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/3)
            }
        }
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 40, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell else {
            return
        }
        didSelectCell?(cell)
    }
}
