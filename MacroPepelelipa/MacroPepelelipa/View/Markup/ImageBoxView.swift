//
//  ImageBoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class ImageBoxView: UIView, BoxView {
    
    internal var state: BoxViewState {
        didSet {
            switch state {
            case .idle:
                boxViewBorder.isHidden = true
            case .editing:
                boxViewBorder.isHidden = false
            }
        }
    }
    
    internal var owner: MarkupTextView
    
    internal var internalFrame: CGRect = .zero
    
    internal var boxViewBorder = CAShapeLayer()
    
    internal var markupUIImage: UIImage
    
    internal lazy var markupImageView: UIImageView = {
        let imageView = UIImageView(image: markupUIImage)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    internal init(frame: CGRect, owner: MarkupTextView, image: UIImage) {  
        self.owner = owner
        self.state = .editing
        self.markupUIImage = image

        super.init(frame: frame)
        
        self.addSubview(markupImageView)
        self.markupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpImageViewConstraints()
        setUpBorder()   
        self.layer.addSublayer(boxViewBorder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageViewConstraints() {
        NSLayoutConstraint.activate([
            markupImageView.topAnchor.constraint(equalTo: self.topAnchor),
            markupImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            markupImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            markupImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /**
     Draw the text box border.
     */
    func setUpBorder() {
        boxViewBorder.strokeColor = UIColor.actionColor?.cgColor
        boxViewBorder.lineDashPattern = [2, 2]
        boxViewBorder.frame = self.bounds
        boxViewBorder.fillColor = nil
        boxViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
    }
    
}