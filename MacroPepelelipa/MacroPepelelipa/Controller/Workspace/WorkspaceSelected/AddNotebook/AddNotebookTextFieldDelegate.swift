//
//  AddNotebokkTextFieldDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

class AddNotebookTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
