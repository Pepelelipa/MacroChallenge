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

    private weak var viewController: UIViewController?
    
    private var colors: [UIColor] {
        UIColor.notebookColors
    }
    
    // MARK: - Initializers
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // MARK: - UICollectionViewDataSource functions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorSelectionCollectionViewCell.cellID(), for: indexPath)
                as? ColorSelectionCollectionViewCell else {
            let alertController = UIAlertController(
                title: "Error presenting notebook creation".localized(),
                message: "The app could not present a color".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A color cell could not be loaded in the creation of a notebook".localized())

            viewController?.present(alertController, animated: true, completion: nil)
            return UICollectionViewCell()
        }
        cell.color = colors[indexPath.row]

        return cell
    }
}
