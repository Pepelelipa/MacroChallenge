//
//  MarkupToogleButton.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupToggleButton: UIButton {
    
    var baseColor: UIColor?
    var selectedColor: UIColor?
    
    init(normalStateImage: UIImage?, title: String?, baseColor: UIColor? = UIColor.placeholderColor, selectedColor: UIColor? = UIColor.bodyColor) {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        
        self.baseColor = baseColor
        self.selectedColor = selectedColor
                
        self.tintColor = baseColor
        
        if let titleLabel = title {
            self.setTitleColor(baseColor, for: .normal)
            self.setTitleColor(selectedColor, for: .selected)
            setFont(fontName: titleLabel)
        }
        
        self.setBackgroundImage(normalStateImage, for: .normal)
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.backgroundColor = color
        
        self.layer.cornerRadius = frame.height / 2
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
    }
    
    private func setFont(fontName: String) {
        guard let font = UIFont(name: fontName, size: 16) else {
            return
        }
        self.titleLabel?.font = font
    }
    
    public func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    @objc private func toogleButton() {
        self.isSelected.toggle()
        
        if isSelected {
            self.tintColor = selectedColor
        } else {
            self.tintColor = baseColor
        }
    }
}
