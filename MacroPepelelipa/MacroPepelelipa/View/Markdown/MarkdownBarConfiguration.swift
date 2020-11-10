//
//  MarkupBarConfiguration.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import PhotosUI
import MarkdownText

internal class MarkdownBarConfiguration {    
    
    // MARK: - Variables and Constants

    private weak var textView: MarkdownTextView?
    private weak var markupViewController: MarkupContainerViewController?
    
    internal weak var observer: MarkupToolBarObserver?
    
    // MARK: - Initializers
    internal init(owner: MarkdownTextView) {
        self.textView = owner
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let owner = coder.decodeObject(forKey: "owner") as? MarkdownTextView else {
            return nil
        }
        self.init(owner: owner)
    }
     
    // MARK: UIBarButtonItem functions
    
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
        
        let listButton = createBarButtonItem(imageName: "text.badge.plus", systemImage: true, objcFunc: #selector(addList))
        // TODO: - needs VoiceOver
        barButtonItems.append(listButton)
        
        let paragraphButton = createBarButtonItem(imageName: "paragraph", systemImage: true, objcFunc: #selector(addHeader))
        // TODO: - needs VoiceOver
        barButtonItems.append(paragraphButton)
        
        let imageGalleryButton = createBarButtonItem(imageName: "photo", systemImage: true, objcFunc: #selector(photoPicker(_:)))
        imageGalleryButton.accessibilityLabel = "Add image label".localized()
        imageGalleryButton.accessibilityHint = "Add image hint".localized()
        barButtonItems.append(imageGalleryButton)
        
        let textBoxButton = createBarButtonItem(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        textBoxButton.accessibilityHint = "Text box hint".localized()
        barButtonItems.append(textBoxButton)
        
        let paintbrushButton = createBarButtonItem(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        paintbrushButton.accessibilityLabel = "Format".localized()
        paintbrushButton.accessibilityLabel = "Format hint".localized()
        barButtonItems.append(paintbrushButton)
        
        return barButtonItems
    }
    
    // MARK: UIButton functions
    
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
        
        let listButton = createButton(imageName: "text.badge.plus", systemImage: true, objcFunc: #selector(addListButton))
        buttons.append(listButton)
        
        let paragraphButton = createButton(imageName: "paragraph", systemImage: true, objcFunc: #selector(addHeaderButton))
        buttons.append(paragraphButton)
        
        let imageGalleryButton = createButton(imageName: "photo", systemImage: true, objcFunc: #selector(photoPicker(_:)))
        buttons.append(imageGalleryButton)
        
        let textBoxButton = createButton(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        buttons.append(textBoxButton)
        
        let paintbrushButton = createButton(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        buttons.append(paintbrushButton)
        
        return buttons
    }

    // MARK: Action functions
    
    /**
    In this funcion, we toggle the color of the button when the button is selected.
     - Parameter sender: The UIButton.
    */
    @objc internal func toogleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.tintColor = UIColor.actionColor
        } else {
            sender.tintColor = UIColor.placeholderColor
        }
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a list, adding it manually, when the function receives a UIBarButtonItem.
    - Parameter listButton: The UIBarButtonItem for the list items.
    */
    @objc internal func addList(listButton: UIBarButtonItem) {
        if listButton.image == UIImage(systemName: "text.badge.plus") {
            listButton.image = UIImage(systemName: "list.bullet")
            textView?.addList(.bullet)
        } else if listButton.image == UIImage(systemName: "list.bullet") {
            listButton.image = UIImage(systemName: "list.number")
            textView?.addList(.numeric)
        } else {
            listButton.image = UIImage(systemName: "text.badge.plus")
            // TODO: remove the list so that it can change to the correct button, without any type of bullet.
        }
    }

    /**
     In this funcion, we deal with the toolbar button for adding a list, adding it manually, when the function receives a UIButton.
     - Parameter listButton: The UIButton for the list items.
     */
    @objc internal func addListButton(listButton: UIButton) {
        if listButton.backgroundImage(for: .normal) == UIImage(systemName: "list.number") {
            listButton.setBackgroundImage(UIImage(systemName: "list.bullet"), for: .normal)
            textView?.addList(.numeric)
        } else {
            listButton.setBackgroundImage(UIImage(systemName: "list.number"), for: .normal)
            textView?.addList(.bullet)
        }
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
     - Parameter paragraphButton: The UIBarButtonItem for the items for the paragraph interaction.
    */
    @objc internal func addHeader(paragraphButton: UIBarButtonItem) {
        if let textView = textView {
            let style: FontStyle
            if paragraphButton.image == UIImage(systemName: "paragraph") {
                paragraphButton.image = UIImage(named: "h1")
                style = .h1
            } else if paragraphButton.image == UIImage(named: "h1") {
                paragraphButton.image = UIImage(named: "h2")
                style = .h2
            } else if paragraphButton.image == UIImage(named: "h2") {
                paragraphButton.image = UIImage(named: "h3")
                style = .h3
            } else {
                paragraphButton.image = UIImage(systemName: "paragraph")
                style = .paragraph
            }
            textView.setFont(to: textView.activeFont.toStyle(style))
        }
    }
    
    /**
    In this funcion, we deal with the toolbar button for adding a header, adding it manually.
     - Parameter paragraphButton: The UIButton for the items for the paragraph interaction.
    */
    @objc internal func addHeaderButton(paragraphButton: UIButton) {

        if let textView = textView {
            let style: FontStyle
            if paragraphButton.backgroundImage(for: .normal) == UIImage(systemName: "paragraph") {
                paragraphButton.setBackgroundImage(UIImage(named: "h1"), for: .normal)
                style = .h1
            } else if paragraphButton.backgroundImage(for: .normal) == UIImage(named: "h1") {
                paragraphButton.setBackgroundImage(UIImage(named: "h2"), for: .normal)
                style = .h2
            } else if paragraphButton.backgroundImage(for: .normal) == UIImage(named: "h2") {
                paragraphButton.setBackgroundImage(UIImage(named: "h3"), for: .normal)
                style = .h3
            } else {
                paragraphButton.setBackgroundImage(UIImage(systemName: "paragraph"), for: .normal)
                style = .paragraph
            }
            textView.setFont(to: textView.activeFont.toStyle(style))
        }
    }
    
    @objc internal func addTextBox() {
        observer?.createTextBox(transcription: nil)
    }
    
    @objc private func openEditTextContainer() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            observer?.changeTextViewInput(isCustom: true)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            observer?.openPopOver()
        }
        
    }
    
    @objc internal func photoPicker(_ sender: NSObject) {
        observer?.presentPicker(sender)
    }
}
