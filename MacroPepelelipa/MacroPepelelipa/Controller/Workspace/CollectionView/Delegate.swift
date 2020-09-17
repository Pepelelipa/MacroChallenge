//
//  CollectionViewFlowLayoutDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable type_name

import UIKit

internal class WorkspaceCollectionViewFlowLayoutDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 157.5, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 3, left: 3, bottom: 3, right: 3)
    }
}
