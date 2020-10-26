//
//  EditableCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 26/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class EditableCollectionViewCell: UICollectionViewCell {
    internal var didChangeEditing: ((Bool) -> Void)?

    internal var isEditing: Bool = false {
        didSet {
            didChangeEditing?(isEditing)
        }
    }
}
