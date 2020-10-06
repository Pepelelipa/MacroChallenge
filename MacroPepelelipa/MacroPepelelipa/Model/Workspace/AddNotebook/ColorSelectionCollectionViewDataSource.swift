//
//  ColorSelectionCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 05/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class ColorSelectionCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var colors: [UIColor] {
        UIColor.notebookColors
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorSelectionCollectionViewCell.cellID(), for: indexPath)
                as? ColorSelectionCollectionViewCell else {
            fatalError("Sorry not sorry")
        }
        cell.color = colors[indexPath.row]

        return cell
    }
}
