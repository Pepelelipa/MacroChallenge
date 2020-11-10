//
//  SearchResultCollectionReusableView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 28/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class SearchResultCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Variables and Constants
    
    private let lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.titleColor ?? .black
        lbl.font = UIFont.defaultHeader.toStyle(.h1)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    
    internal var text: String? {
        get {
            return lblName.text
        }
        set {
            lblName.text = newValue
        }
    } 
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(lblName)
        setupConstraints()
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Functions

    private func setupConstraints() {                                
        NSLayoutConstraint.activate([
            lblName.trailingAnchor.constraint(equalTo: trailingAnchor),
            lblName.topAnchor.constraint(equalTo: topAnchor),
            lblName.widthAnchor.constraint(equalTo: widthAnchor),
            lblName.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    internal class func cellID() -> String {
        "searchResultReusableView"
    }
}
