//
//  MarkupToogleButton.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupToogleButton: UIButton {
    
    init(normalStateImage: UIImage?, title: String?) {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        
        self.tintColor = UIColor(named: "Placeholder")
        
        if let titleLabel = title {
            self.setTitleColor(UIColor(named: "Placeholder"), for: .normal)
            self.setTitleColor(UIColor(named: "Body"), for: .selected)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFont(fontName: String) {
        guard let font = UIFont(name: fontName, size: 16) else {
            return
        }
        self.titleLabel?.font = font
    }
    
    @objc private func toogleButton() {
        self.isSelected.toggle()
        
        if isSelected {
            self.tintColor = UIColor(named: "Body")
        } else {
            self.tintColor = UIColor(named: "Placeholder")
        }
    }
}
