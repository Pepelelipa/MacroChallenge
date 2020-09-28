//
//  MarkupTextFieldDelegate.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    internal weak var observer: TextEditingDelegateObserver?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        observer?.textEditingDidBegin()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        observer?.textEditingDidEnd()
    }
    
}
