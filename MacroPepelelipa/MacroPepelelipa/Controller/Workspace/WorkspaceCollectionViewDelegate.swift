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
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.height/2)
        } else {
            if UIDevice.current.orientation.isLandscape {
                size = CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.height/1.5)
            } else {
                size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
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
