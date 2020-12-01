//
//  ColorSelectionCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 05/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class ColorSelectionCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Variables and Constants
    
    private var colors: [UIColor] {
        UIColor.notebookColors
    }
    
    // MARK: - UICollectionViewDataSource functions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorSelectionCollectionViewCell.cellID(), for: indexPath)
                as? ColorSelectionCollectionViewCell else {
            let title = "Error presenting notebook creation".localized()
            let message = "A color cell could not be loaded in the creation of a notebook".localized()
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            return UICollectionViewCell()
        }
        cell.color = colors[indexPath.row]
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "nb\(indexPath.row)".localized()

        return cell
    }
}
