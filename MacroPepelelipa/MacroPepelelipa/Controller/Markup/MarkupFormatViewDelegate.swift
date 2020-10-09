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
    
    init(viewController: NotesViewController) {
        self.viewController = viewController
        self.textView = viewController.textView
    }
    
    /**
     Dismisses the custom input view.
     */
    @objc public func dismissContainer() {
        viewController?.changeTextViewInput(isCustom: false)
    }
    
    /**
     Makes the selected or coming text italic.
     */
    @IBAction public func makeTextItalic(_ sender: MarkupToggleButton) {
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
    @IBAction public func makeTextBold(_ sender: MarkupToggleButton) {
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
    @IBAction public func changeTextColor(_ sender: MarkupToggleButton) {
        if let textView = self.textView,
            let color = sender.backgroundColor {
            sender.isSelected = textView.setTextColor(color)
            viewController?.markupContainerView.updateColorSelectors(sender: sender)
        }
    }
    
    /**
      Gives the selected of coming text highlighted.
     */
    @objc public func highlightText(_ sender: MarkupToggleButton) {
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
    @objc public func changeTextFont(_ sender: MarkupToggleButton) {
        if let textView = self.textView,
           let font = sender.titleLabel?.font {
            sender.isSelected = textView.setTextFont(font)
            viewController?.markupContainerView.updateFontSelectors(sender: sender)
        }
    }
}
