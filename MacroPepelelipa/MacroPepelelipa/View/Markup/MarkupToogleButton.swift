//
//  MarkupToogleButton.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupToogleButton: UIButton {
    
    init(frame: CGRect,normalStateImage: UIImage?, highlightedStateImage: UIImage?, title: String?) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(toogleButton), for: .touchDown)
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        
        if let titleLabel = title {
            self.setTitleColor(UIColor(named: "Placeholder"), for: .normal)
            self.setTitleColor(UIColor(named: "Title"), for: .selected)
            setFont(fontName: titleLabel)
        }
        
        self.setImage(normalStateImage, for: .normal)
        self.setImage(highlightedStateImage, for: [.selected])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFont(fontName: String){
        guard let _ = UIFont(name: fontName, size: 16) else {
            return
        }
        setFont(fontName: fontName)
    }
    
    @objc private func toogleButton() {
        self.isSelected.toggle()
    }
}
