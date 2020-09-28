//
//  MarkupToolBar.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI

enum ListStyle {
    case bullet
    case numeric
    case quote
}

internal class MarkupToolBar: UIToolbar {
    
    private weak var textView: MarkupTextView?
    private weak var viewController: UIViewController?
    private var pickerDelegate: MarkupPhotoPickerDelegate?
    
    private var listButton: UIBarButtonItem?
    
    private var listStyle: ListStyle = .bullet
    
    init(frame: CGRect, owner: MarkupTextView, controller: UIViewController) {
        self.textView = owner
        self.viewController = controller
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = UIColor(named: "Tools")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
    private func setUpButtons() {
        listButton = createBarButtonItem(systemImageName: "list.bullet", objcFunc: #selector(addList))
        
        let imageGalleryButton = createBarButtonItem(systemImageName: "photo", objcFunc: #selector(photoPicker))
        let textBoxButton = createBarButtonItem(systemImageName: "textbox", objcFunc: nil)
        let paintbrushButton = createBarButtonItem(systemImageName: "paintbrush", objcFunc: nil)
        let paragraphButton = createBarButtonItem(systemImageName: "paragraph", objcFunc: #selector(headerAction))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [flexible, textBoxButton, flexible, imageGalleryButton]
        for _ in 0...9 {
            self.items?.append(flexible)
        }
        
        self.items?.append(paintbrushButton)
        self.items?.append(flexible)
        
        if let listBtn = listButton {
            self.items?.append(listBtn)
            self.items?.append(flexible)
        }
        
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
    private func createBarButtonItem(systemImageName: String, objcFunc: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: objcFunc)
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
    */
    
    @objc private func headerAction() {
        guard let guardedTextView = textView else {
            return
        }
        
        let attributedText = NSMutableAttributedString(attributedString: guardedTextView.attributedText)
        
        let attibutedString = NSMutableAttributedString(string: "\n#")

        attributedText.append(attibutedString)
                
        textView?.attributedText = attributedText          
    }
    
    /**
     In this function, we handle the toolbar button to open the image library. There we instantiate a PHPickerViewController and set its delegate. Finally, there is a present from the instantiated view controller.
    */
    
    @objc private func photoPicker() {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//
//        pickerDelegate = MarkupPhotoPickerDelegate()
//
//        let picker = PHPickerViewController(configuration: config)
//
//        picker.delegate = pickerDelegate
//
//        guard let controller = viewController else {
//            return
//        }
//
//        controller.present(picker, animated: true, completion: nil)
    }
    
    /**
    In this funcion, we deal with the toolbar button for bold text, adding bold manually.
    */
    @objc private func pressBoldButton() {
        guard let guardedTextView = textView else { 
            return 
        }
        let attibutedText = NSMutableAttributedString(attributedString: guardedTextView.attributedText)
        
        let boldFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        
        let range = guardedTextView.selectedRange
        
        let attribute = [NSAttributedString.Key.font: boldFont]
            
        attibutedText.addAttributes(attribute, range: range)
        
        guardedTextView.attributedText = attibutedText
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a list, adding it manually.
    */
    @objc private func addList() {
        guard let guardedTextView = textView else {
            return
        }
            
        let lineCleared = guardedTextView.clearIndicatorCharacters()
        var nextStyle: ListStyle = .bullet
        
        guardedTextView.addList(of: listStyle, lineCleared)
        
        switch listStyle {
        case .bullet:
            listButton?.image = UIImage(systemName: "list.number")
            MarkdownQuote.isQuote = false
            nextStyle = .numeric
        case .numeric:
            listButton?.image = UIImage(systemName: "text.quote")
            MarkdownList.isList = false
            nextStyle = .quote
        case .quote:
            listButton?.image = UIImage(systemName: "list.bullet")
            MarkdownNumeric.isNumeric = false
            nextStyle = .bullet
        }
            
        listStyle = nextStyle
    }
}
