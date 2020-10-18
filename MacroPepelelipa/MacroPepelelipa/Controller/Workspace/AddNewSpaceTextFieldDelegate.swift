//
//  AddNotebokkTextFieldDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class AddNewSpaceTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    internal weak var workspaceObserver: AddWorkspaceObserver?
    internal weak var notesObserver: AddNoteObserver?
    
    // MARK: - UITextFieldDelegate functions
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        workspaceObserver?.addWorkspace()
        notesObserver?.addNote()
        textField.resignFirstResponder()
        return true
    }
}
