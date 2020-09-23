//
//  MarkupToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class MarkupToolBar: UIToolbar {
    
    let textView: MarkupTextView?
    
    init(frame: CGRect, owner: MarkupTextView) {
        self.textView = owner        
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = #colorLiteral(red: 0.7882352941, green: 0.768627451, blue: 0.8117647059, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
    private func setUpButtons() {
        
        let imageGalleryButton = createBarButtonItem(systemImageName: "photo", objcFunc: nil)
        let textBoxButton = createBarButtonItem(systemImageName: "textbox", objcFunc: nil)
        let listButton = createBarButtonItem(systemImageName: "text.badge.plus", objcFunc: nil)
        let paintbrushButton = createBarButtonItem(systemImageName: "paintbrush", objcFunc: nil)
        let paragraphButton = createBarButtonItem(systemImageName: "paragraph", objcFunc: nil)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [flexible, textBoxButton, flexible, imageGalleryButton]
        for _ in 0...9 {
            self.items?.append(flexible)
        }
        self.items?.append(paintbrushButton)
        self.items?.append(flexible)
        self.items?.append(listButton)
        self.items?.append(flexible)
        self.items?.append(paragraphButton)
        self.items?.append(flexible)
    }    
    
    /**
     This private method creates a UIBarButtonItem with an image and an Objective-C function.
     
     - Parameters:
        - systemImageName: A String containing the name of the button image.
        - objcFunc: An optional Selector to be added to the button.
     
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    private func createBarButtonItem(systemImageName: String, objcFunc: Selector? ) -> UIBarButtonItem {
        guard let guardedObjcFunc = objcFunc else {
            return UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: nil)
        }
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: guardedObjcFunc)
        return barButtonItem
    }
}
