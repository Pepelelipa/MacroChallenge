//
//  AddNotebookToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class AddNotebookToolBar: UIToolbar {
    
    private lazy var doneButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(placeHolderMethod))
        barButton.tintColor = UIColor.actionColor
        return barButton
    }()
    
    private var owner: UITextField
    
    init(frame: CGRect, owner: UITextField) {
        self.owner = owner
        super.init(frame: frame)
                
        setupToolBarSpace()
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
    }
    
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect, let owner = coder.decodeObject(forKey: "owner") as? UITextField else {
            return nil
        }
        self.init(frame: frame, owner: owner)
    }
    
    @objc func placeHolderMethod() {
        self.owner.resignFirstResponder()
    }
    
    private func setupToolBarSpace() {
        let flexibe = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [flexibe, doneButton]
        self.items = items
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
//    private func setUpButtons() {
//        
//        guard let barButtonItems = markupBarConfiguration?.setUpButtons() else {
//            return
//        }
//
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        self.items = [flexible, barButtonItems[3], flexible, barButtonItems[2]]
//        for _ in 0...9 {
//            self.items?.append(flexible)
//        }
//        
//        self.items?.append(barButtonItems[4])
//        self.items?.append(flexible)
//        
//        self.items?.append(barButtonItems[0])
//        self.items?.append(flexible)
//        
//        MarkupToolBar.paragraphButton = barButtonItems[1]
//        
//        if let paragraphBtn = MarkupToolBar.paragraphButton {
//            self.items?.append(paragraphBtn)
//            self.items?.append(flexible)
//        }
//    }
}
