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
    
    /**
     Initializes the button with an image or a title, with a base color and a selected color.
     */
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
    
    /**
     Initializes the button with a frame and color, making the view a circle.
     */
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.backgroundColor = color
        
        self.layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the buttons font.
     
     - Parameter fontName: The string containing the font's name.
     */
    private func setFont(fontName: String) {
        guard let font = UIFont(name: fontName, size: 16) else {
            return
        }
        self.titleLabel?.font = font
    }
    
    /**
     Sets the corner radius to be equal to half the frame's height.
     */
    public func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    /**
     This method changes the button's color based on its selection state.
     */
    @objc private func toogleButton() {
        self.isSelected.toggle()
        
        if isSelected {
            self.tintColor = selectedColor
        } else {
            self.tintColor = baseColor
        }
    }
}
