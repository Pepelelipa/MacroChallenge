//
//  WorkspaceCollectionViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspacesCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var didSelectCell: ((WorkspaceCollectionViewCell) -> Void)?
    init(_ didSelectCell: @escaping (WorkspaceCollectionViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize
        let isLandscape = UIDevice.current.orientation.isLandscape
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
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 50
        }
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
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
