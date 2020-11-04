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
        
        guard let barButtonItems = markupBarConfiguration?.setUpButtons() else {
            return
        }

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [flexible, barButtonItems[3], flexible, barButtonItems[2]]
        for _ in 0...9 {
            self.items?.append(flexible)
        }
        
        self.items?.append(barButtonItems[4])
        self.items?.append(flexible)
        
        self.items?.append(barButtonItems[0])
        self.items?.append(flexible)
        
        MarkdownToolBar.paragraphButton = barButtonItems[1]
        
        if let paragraphBtn = MarkdownToolBar.paragraphButton {
            self.items?.append(paragraphBtn)
            self.items?.append(flexible)
        }
    }
}
