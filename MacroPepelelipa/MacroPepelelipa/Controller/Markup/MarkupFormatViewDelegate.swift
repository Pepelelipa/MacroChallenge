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
    private weak var textView: MarkupTextView?
    private weak var formatView: MarkupFormatView?
    
    init(viewController: NotesViewController) {
        self.viewController = viewController
        self.textView = viewController.textView
    }
    
    /**
     Dismisses the custom input view.
     */
    @objc internal func dismissContainer() {
        viewController?.changeTextViewInput(isCustom: false)
    }
    
    /**
     Makes the selected or coming text italic.
     */
    @IBAction internal func makeTextItalic(_ sender: MarkupToggleButton) {
        if textView?.selectedRange.length == 0 {
            if sender.isSelected {
                textView?.setFontAttributes(with: .traitItalic)
            } else {
                textView?.removeFontTrait(.traitItalic)
            }
        } else {
            textView?.addItalic()
            sender.isSelected = false
        }
    }
    
    /**
     Makes the selected or coming text bold.
     */
    @IBAction internal func makeTextBold(_ sender: MarkupToggleButton) {
        if textView?.selectedRange.length == 0 {
            if sender.isSelected {
                textView?.setFontAttributes(with: .traitBold)
            } else {
                textView?.removeFontTrait(.traitBold)
            }
        } else {
            textView?.addBold()
            sender.isSelected = false
        }
    }
    
    /**
     Changes the color for the selected or coming text.
     */
    @IBAction internal func changeTextColor(_ sender: MarkupToggleButton) {
        if let textView = self.textView,
            let color = sender.backgroundColor {
            sender.isSelected = textView.setTextColor(color)
            formatView?.updateColorSelectors(sender: sender)
        }
    }
    
    /**
      Gives the selected of coming text highlighted.
     */
    @objc internal func highlightText(_ sender: MarkupToggleButton) {
        if textView?.selectedRange.length == 0 {
            if sender.isSelected {
                textView?.setTextToHighlight()
            } else {
                 textView?.setTextToNormal()
            }
        } else {
            textView?.setBackgroundColor()
            sender.isSelected = false
        }
    }
    
    /**
     Changes the font for the selected or coming text.
     */
    @objc internal func changeTextFont(_ sender: MarkupToggleButton) {
        if let textView = self.textView,
           let font = sender.titleLabel?.font {
            sender.isSelected = textView.setTextFont(font)
            formatView?.updateFontSelectors(sender: sender)
        }
    }
    
    internal func setFormatView(_ formatView: MarkupFormatView) {
        self.formatView = formatView
    }
}
