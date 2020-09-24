//
//  MarkupTextField.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextField: UITextField {
    
    init(frame: CGRect, placeholder: String, paddingSpace: CGFloat) {
        super.init(frame: frame)
        
        self.placeholder = placeholder
        
        self.backgroundColor = UIColor(named: "Background")
        self.textColor = UIColor(named: "Title")
        self.tintColor = UIColor(named: "Highlight")
        
        let markdownFont = MarkdownParser.defaultFont.withSize(26).bold()
        self.font = markdownFont
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addPaddingSpace(space: paddingSpace)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This method adds padding to the sides of the UITextField.
     
     - Parameter space: A CGFloat indicating the padding space on each side.
     */
    private func addPaddingSpace(space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}
