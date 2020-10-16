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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    internal init(frame: CGRect, owner: MarkupTextView, image: UIImage) {  
        self.owner = owner
        self.state = .idle
        self.markupUIImage = image

        super.init(frame: frame)
        
        self.addSubview(markupImageView)
        self.markupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpImageViewConstraints()
        setUpBorder()   
        self.layer.addSublayer(boxViewBorder)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect, 
              let owner = coder.decodeObject(forKey: "owner") as? MarkupTextView, 
              let image = coder.decodeObject(forKey: "image") as? UIImage else {
            return nil
        }
        self.init(frame: frame, owner: owner, image: image)
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
