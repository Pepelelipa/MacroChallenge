//
//  MarkupFormatViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

class MarkupFormatViewDelegate {
    
    private weak var viewController: NotesViewController?
    
    init(viewController: NotesViewController) {
        self.viewController = viewController
    }
    
    /**
     Dismisses the custom input view.
     */
    @objc public func dismissContainer() {
        viewController?.changeTextViewInput(isCustom: false)
    }
    
    /**
     This is a placeholder action. **It must be changed when the buttons are implemented.** 
     */
    @objc public func placeHolderAction() {
        
    }
    
    /**
     Makes the selected or coming text italic.
     */
    @objc public func makeTextItalic() {
        
    }
    
    /**
     Makes the selected or coming text bold.
     */
    @objc public func makeTextBold() {
        
    }
    
    /**
      Gives the selected of coming text highlighted.
     */
    @objc public func highlightText() {
        
    }
}
