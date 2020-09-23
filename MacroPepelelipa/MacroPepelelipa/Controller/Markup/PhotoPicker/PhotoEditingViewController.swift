//
//  PhotoEditingViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

class PhotoEditingViewController: UIViewController {
    
    public var editingImage: UIImage?
    
    private lazy var editingImageView: UIImageView = {
        let imageView = UIImageView(image: editingImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editingImageView)
    }
    
    override func viewDidLayoutSubviews() {
        setUpImageViewConstraints()
    }
    
    private func setUpImageViewConstraints() {
        NSLayoutConstraint.activate([
            editingImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            editingImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            editingImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            editingImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
