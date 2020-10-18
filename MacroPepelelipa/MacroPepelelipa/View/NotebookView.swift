//
//  NotebookView.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 01/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookView: UIImageView {
    
    // MARK: - Variables and Constants
    
    private let shadowView = UIImageView(image: #imageLiteral(resourceName: "BooklikeShadow"))

    internal var color: UIColor {
        get {
            return self.tintColor
        }
        set {
            shadowView.alpha = newValue.cgColor.alpha
            self.tintColor = newValue
        }
    }
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.image = #imageLiteral(resourceName: "Book")
        self.color = color
        self.contentMode = .scaleToFill
        self.translatesAutoresizingMaskIntoConstraints = false

        shadowView.contentMode = .scaleToFill
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadowView)

        setupConstraints()
    }

    internal convenience override init(frame: CGRect) {
        self.init(frame: frame, color: UIColor.randomNotebookColor() ?? .clear)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        if let color = coder.decodeObject(forKey: "color") as? UIColor {
            self.init(frame: frame, color: color)
        } else {
            self.init(frame: frame)
        }
    }
    
    // MARK: - Functions

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            shadowView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            shadowView.widthAnchor.constraint(equalTo: self.widthAnchor),
            shadowView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
