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

    private var roundView: UIView
    internal var color: UIColor? {
        get {
            return roundView.backgroundColor
        }
        set {
            roundView.backgroundColor = newValue
        }
    }

    override init(frame: CGRect) {
        roundView = UIView(frame: .zero)
        roundView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)

        addSubview(roundView)

        NSLayoutConstraint.activate([
            roundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            roundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            roundView.widthAnchor.constraint(equalTo: widthAnchor),
            roundView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        roundView.layer.cornerRadius = frame.height/2
    }

    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }

}
