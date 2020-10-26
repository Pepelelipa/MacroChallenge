//
//  EditableCollectionView.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 26/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class EditableCollectionView: UICollectionView {
    internal func setEditing(_ editing: Bool) {
        for cell in visibleCells {
            if let editableCell = cell as? EditableCollectionViewCell {
                editableCell.isEditing = editing
            }
        }
        isEditing = editing
    }
}
