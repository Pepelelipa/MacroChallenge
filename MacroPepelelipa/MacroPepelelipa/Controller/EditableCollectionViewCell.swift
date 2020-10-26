//
//  EditableCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 26/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal protocol EditableCollectionViewCell: UICollectionViewCell {
    var isEditing: Bool { get set }
}
