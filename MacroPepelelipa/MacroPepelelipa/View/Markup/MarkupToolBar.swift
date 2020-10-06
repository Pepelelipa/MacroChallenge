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

enum HeaderStyle {
    case h1
    case h2
    case h3
    case paragraph
}

internal class MarkupToolBar: UIToolbar {
    
    internal weak var observer: MarkupToolBarObserver?
    
    private weak var textView: MarkupTextView?
    private var pickerDelegate: MarkupPhotoPickerDelegate?
    
    private var listButton: UIBarButtonItem?
    private static var paragraphButton: UIBarButtonItem?
    
    private var listStyle: ListStyle = .bullet
    public static var headerStyle: HeaderStyle = .h1 {
        didSet {
            if MarkupToolBar.headerStyle == .h1 {
                paragraphButton?.image = UIImage(named: "h1")
            }
        }
    }
    
    init(frame: CGRect, owner: MarkupTextView) {
        self.textView = owner
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = .toolsColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
    private func setUpButtons() {
        listButton = createBarButtonItem(imageName: "list.bullet", systemImage: true, objcFunc: #selector(addList))
        MarkupToolBar.paragraphButton = createBarButtonItem(imageName: "h1", systemImage: false, objcFunc: #selector(addHeader))        
        let imageGalleryButton = createBarButtonItem(imageName: "photo", systemImage: true, objcFunc: #selector(photoPicker))

        let textBoxButton = createBarButtonItem(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        let paintbrushButton = createBarButtonItem(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))

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
        
        if let paragraphBtn = MarkupToolBar.paragraphButton {
            self.items?.append(paragraphBtn)
            self.items?.append(flexible)
        }
    }
    
    @objc private func openEditTextContainer() {
        observer?.changeTextViewInput(isCustom: true)
    }
    
    /**
     This private method creates a UIBarButtonItem with an image and an Objective-C function.
     
     - Parameters:
        - systemImageName: A String containing the name of the button image.
        - objcFunc: An optional Selector to be added to the button.
     
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    private func createBarButtonItem(imageName: String, systemImage: Bool, objcFunc: Selector?) -> UIBarButtonItem {
        var buttonImage: UIImage?
        if systemImage {
            buttonImage = UIImage(systemName: imageName)
        } else {
            buttonImage = UIImage(named: imageName)
        }
        
        return UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: objcFunc)
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
    */
    @objc private func addHeader() {
        textView?.addHeader(with: MarkupToolBar.headerStyle)
        var nextStyle: HeaderStyle = MarkupToolBar.headerStyle
                
        switch MarkupToolBar.headerStyle {
        case .h1:
            MarkupToolBar.paragraphButton?.image = UIImage(named: "h2")
            nextStyle = .h2
        case .h2:
            MarkupToolBar.paragraphButton?.image = UIImage(named: "h3")
            nextStyle = .h3
        case .h3:
            MarkupToolBar.paragraphButton?.image = UIImage(systemName: "paragraph")
            nextStyle = .paragraph
        case .paragraph:
            MarkupToolBar.paragraphButton?.image = UIImage(named: "h1")
            nextStyle = .h1
        }
            
        MarkupToolBar.headerStyle = nextStyle
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
    
    @objc private func addTextBox() {
        let frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
        observer?.addTextBox(with: frame)
    }
}
