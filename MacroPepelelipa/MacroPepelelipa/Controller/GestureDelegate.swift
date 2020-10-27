//
//  GestureDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 26/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class GestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Variables and Constants
    
    private let popup: UIView
    private let textField: UITextField
    
    // MARK: - Initializers
    
    internal init(popup: UIView, textField: UITextField) {
        self.popup = popup
        self.textField = textField
    }
    
    // MARK: - UIGestureRecognizerDelegate functions
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let touchedView = touch.view,
           touchedView.isDescendant(of: popup),
           !textField.isEditing {
            return false
        }
        return true
    }
}
