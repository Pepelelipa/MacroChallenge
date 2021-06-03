//
//  MarkupTextField.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkdownTextField: UITextField {
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, placeholder: String, paddingSpace: CGFloat) {
        super.init(frame: frame)
        
        self.placeholder = placeholder
        
        self.backgroundColor = .backgroundColor
        self.textColor = .titleColor
        self.tintColor = .actionColor
        
        self.font = UIFont.defaultHeader.toStyle(.h1)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        #if targetEnvironment(macCatalyst)
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        #endif
        
        addPaddingSpace(space: paddingSpace)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
              let placeholder = coder.decodeObject(forKey: "placeholder") as? String,
              let paddingSpace = coder.decodeObject(forKey: "paddingSpace") as? CGFloat else {
            return nil
        }

        self.init(frame: frame, placeholder: placeholder, paddingSpace: paddingSpace)
    }

    // MARK: - Functions
    
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
