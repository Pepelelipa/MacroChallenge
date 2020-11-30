//
//  TextEditingDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 30/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

internal class TextEditingDelegate: NSObject, TextEditingDelegateObserver {
    
    private var textBoxes: Set<TextBoxView>
    private var imageBoxes: Set<ImageBoxView>
    private var resizeHandleViews: [ResizeHandleView]
    private var saveNote: () -> Void
    
    init(textBoxes: Set<TextBoxView>, imageBoxes: Set<ImageBoxView>, resizeHandleViews: [ResizeHandleView], saveNote: @escaping () -> Void) {
        self.textBoxes = textBoxes
        self.imageBoxes = imageBoxes
        self.resizeHandleViews = resizeHandleViews
        self.saveNote = saveNote
    }
    
    internal func textEditingDidBegin() {
        DispatchQueue.main.async {
            self.textBoxes.forEach { (textBox) in
                textBox.state = .idle
                textBox.markupTextView.isUserInteractionEnabled = false
            }
            self.imageBoxes.forEach { (imageBox) in
                imageBox.state = .idle
            }
            
            if !self.resizeHandleViews.isEmpty {
                self.resizeHandleViews.forEach { (resizeHandle) in
                    resizeHandle.removeFromSuperview()
                }
            }
        }
    }
    
    internal func textEditingDidEnd() {
        saveNote()
    }
    
}
