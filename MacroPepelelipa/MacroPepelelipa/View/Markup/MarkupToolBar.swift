//
//  MarkupToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class MarkupToolBar: UIToolbar {
    
    private weak var markupBarConfiguration: MarkupBarConfiguration?
    
    private static var paragraphButton: UIBarButtonItem?
    
    public static var headerStyle: HeaderStyle = .h1 {
        didSet {
            if MarkupToolBar.headerStyle == .h1 {
                paragraphButton?.image = UIImage(named: "h1")
            }
        }
    }
    
    init(frame: CGRect, configurations: MarkupBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
    }
    
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
              let configurations = coder.decodeObject(forKey: "configurations") as? MarkupBarConfiguration else {
            return nil
        }

        self.init(frame: frame, configurations: configurations)
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
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
        
        MarkupToolBar.paragraphButton = barButtonItems[1]
        
        if let paragraphBtn = MarkupToolBar.paragraphButton {
            self.items?.append(paragraphBtn)
            self.items?.append(flexible)
        }
    }
}
