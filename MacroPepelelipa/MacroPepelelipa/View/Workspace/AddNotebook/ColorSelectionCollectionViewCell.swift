//
//  ColorSelectionCollectionViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 05/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class ColorSelectionCollectionViewCell: UICollectionViewCell {
    internal class func cellID() -> String { "colorSelectionCell" }

    internal var color: UIColor? {
        get {
            return backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/2
    }

    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }

}
