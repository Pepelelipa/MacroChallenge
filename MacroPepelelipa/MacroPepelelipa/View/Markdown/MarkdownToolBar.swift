//
//  MarkupToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkdownToolBar: UIToolbar {
    
    // MARK: - Variables and Constants
    
    private weak var markupBarConfiguration: MarkdownBarConfiguration?
    private static weak var paragraphButton: UIBarButtonItem?
    private static weak var listButton: UIBarButtonItem?
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, configurations: MarkdownBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
              let configurations = coder.decodeObject(forKey: "configurations") as? MarkdownBarConfiguration else {
            return nil
        }

        self.init(frame: frame, configurations: configurations)
    }
    
    // MARK: - Functions
    
    ///A private method to set up all the Buttons on the UIToolBar.
    private func setUpButtons() {
        
        guard let barButtonItems = markupBarConfiguration?.setUpButtons(),
              let image = barButtonItems[.image],
              let format = barButtonItems[.format],
              let list = barButtonItems[.list],
              let paragraph = barButtonItems[.paragraph] else {
            return
        }

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [flexible, image, flexible]
        
        self.items?.append(format)
        self.items?.append(flexible)
        
        self.items?.append(list)
        self.items?.append(flexible)
        
        MarkdownToolBar.paragraphButton = paragraph
        
        if let paragraphBtn = MarkdownToolBar.paragraphButton {
            self.items?.append(paragraphBtn)
            self.items?.append(flexible)
        }
    }
}
