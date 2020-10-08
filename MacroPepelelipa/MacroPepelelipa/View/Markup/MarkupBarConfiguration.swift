//
//  MarkupBarConfiguration.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

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

internal class MarkupBarConfiguration {    
    internal weak var observer: MarkupToolBarObserver?
    private weak var textView: MarkupTextView?
    private var listStyle: ListStyle = .bullet
    
    init(owner: MarkupTextView) {
        self.textView = owner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc internal func openEditTextContainer() {
        observer?.changeTextViewInput(isCustom: true)
    }
    
    // MARK: UIBarButtonItem
    
    /**
     This internal method creates a UIBarButtonItem with an image and an Objective-C function.
     
     - Parameters:
        - systemImageName: A String containing the name of the button image.
        - systemImage: A Boolean that specifies if the button is a system image or just a normal image.
        - objcFunc: An optional Selector to be added to the button.
     
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    internal func createBarButtonItem(imageName: String, systemImage: Bool, objcFunc: Selector?) -> UIBarButtonItem {
        var buttonImage: UIImage?
        if systemImage {
            buttonImage = UIImage(systemName: imageName)
        } else {
            buttonImage = UIImage(named: imageName)
        }
        
        return UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: objcFunc)
    }
    
    /**
     This internal creates all of the UIBarButtonItems for the tab bar.
     
     - Returns: An array of UIBarButtonItems so that the class that will be using this function can access the buttons.
     */
    internal func setUpButtons() -> [UIBarButtonItem] {
        var barButtonItems: [UIBarButtonItem] = []
        
        let listButton = createBarButtonItem(imageName: "list.bullet", systemImage: true, objcFunc: #selector(addList))
        barButtonItems.append(listButton)
        
        let paragraphButton = createBarButtonItem(imageName: "h1", systemImage: false, objcFunc: #selector(addHeader))
        barButtonItems.append(paragraphButton)
        
        let imageGalleryButton = createBarButtonItem(imageName: "photo", systemImage: true, objcFunc: #selector(photoPicker))
        barButtonItems.append(imageGalleryButton)
        
        let textBoxButton = createBarButtonItem(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        barButtonItems.append(textBoxButton)
        
        let paintbrushButton = createBarButtonItem(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        barButtonItems.append(paintbrushButton)
        
        return barButtonItems
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a list, adding it manually, when the function receives a UIBarButtonItem.
    - Parameters:
        - listButton: The UIBarButtonItem for the list items.
    */
    @objc internal func addList(listButton: UIBarButtonItem) {
        guard let guardedTextView = textView else {
            return
        }
            
        let lineCleared = guardedTextView.clearIndicatorCharacters()
        var nextStyle: ListStyle = .bullet
        
        guardedTextView.addList(of: listStyle, lineCleared)
        
        switch listStyle {
        case .bullet:
            listButton.image = UIImage(systemName: "list.number")
            MarkdownQuote.isQuote = false
            nextStyle = .numeric
        case .numeric:
            listButton.image = UIImage(systemName: "text.quote")
            MarkdownList.isList = false
            nextStyle = .quote
        case .quote:
            listButton.image = UIImage(systemName: "list.bullet")
            MarkdownNumeric.isNumeric = false
            nextStyle = .bullet
        }
        
        listStyle = nextStyle
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
     - Parameters:
            - paragraphButton: The UIBarButtonItem for the items for the paragraph interaction.
    */
    @objc internal func addHeader(paragraphButton: UIBarButtonItem) {
        textView?.addHeader(with: MarkupToolBar.headerStyle)
        var nextStyle: HeaderStyle = MarkupToolBar.headerStyle
                
        switch MarkupToolBar.headerStyle {
        case .h1:
            paragraphButton.image = UIImage(named: "h2")
            nextStyle = .h2
        case .h2:
            paragraphButton.image = UIImage(named: "h3")
            nextStyle = .h3
        case .h3:
            paragraphButton.image = UIImage(systemName: "paragraph")
            nextStyle = .paragraph
        case .paragraph:
            paragraphButton.image = UIImage(named: "h1")
            nextStyle = .h1
        }
            
        MarkupToolBar.headerStyle = nextStyle
    }
    
    // MARK: UIButton
    
    /**
     This internal method creates a UIButton with an image and an Objective-C function.
     
     - Parameters:
        - imageName: A String containing the name of the button image.
        - systemImage: A Boolean that specifies if the button is a system image or just a normal image.
        - objcFunc: An optional Selector to be added to the button.
     
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    internal func createButton(imageName: String, systemImage: Bool, objcFunc: Selector) -> UIButton {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var buttonImage: UIImage?
        if systemImage {
            buttonImage = UIImage(systemName: imageName)
        } else {
            buttonImage = UIImage(named: imageName)
        }
        
        button.setBackgroundImage(buttonImage, for: .normal)
        button.addTarget(self, action: objcFunc, for: .touchUpInside)
        
        return button
    }
    
    /**
     This internal creates all of the UIButtons for the tab bar.
     
     - Returns: An array of UIButtons so that the class that will be using this function can access the buttons.
     */
    internal func setupUIButtons() -> [UIButton] {
        var buttons: [UIButton] = []
        
        let listButton = createButton(imageName: "list.bullet", systemImage: true, objcFunc: #selector(addListButton))
        buttons.append(listButton)
        
        let paragraphButton = createButton(imageName: "h1", systemImage: false, objcFunc: #selector(addHeaderButton))
        buttons.append(paragraphButton)
        
        let imageGalleryButton = createButton(imageName: "photo", systemImage: true, objcFunc: #selector(photoPicker))
        buttons.append(imageGalleryButton)
        
        let textBoxButton = createButton(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        buttons.append(textBoxButton)
        
        let paintbrushButton = createButton(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        buttons.append(paintbrushButton)
        
        return buttons
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
     - Parameters:
            - paragraphButton: The UIButton for the items for the paragraph interaction.
    */
    @objc internal func addHeaderButton(paragraphButton: UIButton) {
        textView?.addHeader(with: MarkupToolBar.headerStyle)
        var nextStyle: HeaderStyle = MarkupToolBar.headerStyle
                
        switch MarkupToolBar.headerStyle {
        case .h1:
            paragraphButton.setBackgroundImage(UIImage(named: "h2"), for: .normal)
            nextStyle = .h2
        case .h2:
            paragraphButton.setBackgroundImage(UIImage(named: "h3"), for: .normal)
            nextStyle = .h3
        case .h3:
            paragraphButton.setBackgroundImage(UIImage(systemName: "paragraph"), for: .normal)
            nextStyle = .paragraph
        case .paragraph:
            paragraphButton.setBackgroundImage(UIImage(named: "h1"), for: .normal)
            nextStyle = .h1
        }
            
        MarkupToolBar.headerStyle = nextStyle
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a list, adding it manually, when the function receives a UIButton.
    - Parameters:
        - listButton: The UIButton for the list items.
    */
    @objc internal func addListButton(listButton: UIButton) {
        guard let guardedTextView = textView else {
            return
        }
            
        let lineCleared = guardedTextView.clearIndicatorCharacters()
        var nextStyle: ListStyle = .bullet
        
        guardedTextView.addList(of: listStyle, lineCleared)
        
        switch listStyle {
        case .bullet:
            listButton.setBackgroundImage(UIImage(systemName: "list.number"), for: .normal)
            MarkdownQuote.isQuote = false
            nextStyle = .numeric
        case .numeric:
            listButton.setBackgroundImage(UIImage(systemName: "text.quote"), for: .normal)
            MarkdownList.isList = false
            nextStyle = .quote
        case .quote:
            listButton.setBackgroundImage(UIImage(systemName: "list.bullet"), for: .normal)
            MarkdownNumeric.isNumeric = false
            nextStyle = .bullet
        }
        
        listStyle = nextStyle
    }
    
    // MARK: General
    
    @objc internal func addTextBox() {
        let frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
        observer?.addTextBox(with: frame)
    }
    
    @objc internal func photoPicker() {

    }
    
}
