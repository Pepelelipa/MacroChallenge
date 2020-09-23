//
//  MarkupTextField.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MarkupTextField : UITextField {
    
    init(frame: CGRect, placeholder: String, paddingSpace: CGFloat) {
        super.init(frame: frame)
        
        self.placeholder = placeholder
        
        self.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
        self.textColor = #colorLiteral(red: 0.1764705882, green: 0.168627451, blue: 0.168627451, alpha: 1)
        self.tintColor = #colorLiteral(red: 0.6352941176, green: 0.3490196078, blue: 1, alpha: 1)
        
        let markdownFont = MarkdownParser.defaultFont.withSize(26).bold()
        self.font = markdownFont
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addPadingSpace(space: paddingSpace)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPadingSpace(space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}
