//
//  AddNotebookToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class AddNewSpaceToolBar: UIToolbar {
    
    // MARK: - Variables and Constants
    
    private var owner: UITextField
    
    private lazy var doneButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        barButton.tintColor = UIColor.actionColor
        return barButton
    }()
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, owner: UITextField) {
        self.owner = owner
        super.init(frame: frame)
                
        setupToolBarSpace()
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect, let owner = coder.decodeObject(forKey: "owner") as? UITextField else {
            return nil
        }
        self.init(frame: frame, owner: owner)
    }
    
    // MARK: - Functions
    
    ///A private method to set up the space layout.
    private func setupToolBarSpace() {
        let flexibe = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [flexibe, doneButton]
        self.items = items
    }
    
    // MARK: - Objective-C functions
    
    @objc func dismissKeyboard() {
        self.owner.resignFirstResponder()
    }
}
