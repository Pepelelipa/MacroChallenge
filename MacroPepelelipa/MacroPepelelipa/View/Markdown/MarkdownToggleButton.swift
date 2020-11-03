//
//  MarkupToogleButton.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkdownToggleButton: UIButton {
    
    // MARK: - Variables and Constants

    internal var baseColor: UIColor?
    internal var selectedColor: UIColor?
    
    // MARK: - Initializers
    
    internal init(normalStateImage: UIImage?, title: String?, baseColor: UIColor? = UIColor.placeholderColor, selectedColor: UIColor? = UIColor.bodyColor, font: UIFont? = nil) {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        
        self.baseColor = baseColor
        self.selectedColor = selectedColor
                
        self.tintColor = baseColor
        
        if title != nil {
            self.setTitleColor(baseColor, for: .normal)
            self.setTitleColor(selectedColor, for: .selected)
            setFont(font)
        }
        
        self.setBackgroundImage(normalStateImage, for: .normal)
    }
    
    internal init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.setImage(UIImage(systemName: "checkmark"), for: .selected)
        self.tintColor = UIColor.backgroundColor
        
        self.baseColor = self.tintColor
        self.selectedColor = self.tintColor
        
        self.backgroundColor = color
        self.layer.cornerRadius = frame.height / 2
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
        let color = coder.decodeObject(forKey: "color") as? UIColor else {
            return nil
        }

        self.init(frame: frame, color: color)
    }
    
    // MARK: - Functions
    
    private func setFont(_ font: UIFont?) {
        guard let titleFont = font else {
            return
        }
        self.titleLabel?.font = titleFont
    }
    
    internal func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    internal func setTintColor() {
        if isSelected {
            self.tintColor = selectedColor
        } else {
            self.tintColor = baseColor
        }
    }
    
    // MARK: - Objective-C functions
    
    @objc internal func toogleButton() {
        self.isSelected.toggle()
        setTintColor()
    }
}
