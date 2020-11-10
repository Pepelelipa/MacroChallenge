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

internal enum BarButtonType: String {
    case list = "List style"
    case paragraph = "Paragraph style"
    case image = "Import image"
    case textBox = "Add text box"
    case format = "Format"
}

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
    
    // MARK: - UIBarButtonItem functions
    
    /**
     This internal method creates a UIBarButtonItem with an image and an Objective-C function.
     - Parameters:
        - systemImageName: A String containing the name of the button image.
        - systemImage: A Boolean that specifies if the button is a system image or just a normal image.
        - objcFunc: An optional Selector to be added to the button.
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    internal func createBarButtonItem(imageName: String, systemImage: Bool, objcFunc: Selector? = nil) -> UIBarButtonItem {
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
     - Returns: A dictionaty of UIBarButtonItems per BarButtonType so that the class that will be using this function can access the buttons.
     */
    internal func setUpButtons() -> [BarButtonType: UIBarButtonItem] {
        var barButtonItems = [BarButtonType: UIBarButtonItem]()
        
        let listButton = createBarButtonItem(imageName: "text.badge.plus", systemImage: true)
        listButton.menu = setupMenu(for: .list)
        barButtonItems[.list] = listButton
        
        let paragraphButton = createBarButtonItem(imageName: "paragraph", systemImage: true)
        paragraphButton.menu = setupMenu(for: .paragraph)
        barButtonItems[.paragraph] = paragraphButton
        
        let imageGalleryButton = createBarButtonItem(imageName: "photo", systemImage: true)
        imageGalleryButton.menu = setupMenu(for: .image)
        barButtonItems[.image] = imageGalleryButton
        
        let textBoxButton = createBarButtonItem(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        barButtonItems[.textBox] = textBoxButton
        
        let paintbrushButton = createBarButtonItem(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        barButtonItems[.format] = paintbrushButton
        
        return barButtonItems
    }
    
    // MARK: - UIButton functions
    
    /**
     This internal method creates a UIButton with an image and an Objective-C function.
     - Parameters:
        - imageName: A String containing the name of the button image.
        - systemImage: A Boolean that specifies if the button is a system image or just a normal image.
        - objcFunc: An optional Selector to be added to the button.
     - Returns: An UIBarButtonItem with an image and a selector, if passed as parameter.
     */
    internal func createButton(imageName: String, systemImage: Bool, objcFunc: Selector? = nil) -> UIButton {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var buttonImage: UIImage?
        if systemImage {
            buttonImage = UIImage(systemName: imageName)
        } else {
            buttonImage = UIImage(named: imageName)
        }
        
        button.setBackgroundImage(buttonImage, for: .normal)
        
        if let action = objcFunc {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        
        return button
    }
    
    /**
     This internal creates all of the UIButtons for the tab bar.
     - Returns: An array of UIButtons so that the class that will be using this function can access the buttons.
     */
    internal func setupUIButtons() -> [BarButtonType: UIButton] {
        var buttons = [BarButtonType: UIButton]()
        
        let listButton = createButton(imageName: "text.badge.plus", systemImage: true)
        listButton.menu = setupMenu(for: .list)
        listButton.showsMenuAsPrimaryAction = true
        buttons[.list] = listButton
        
        let paragraphButton = createButton(imageName: "paragraph", systemImage: true)
        paragraphButton.menu = setupMenu(for: .paragraph)
        paragraphButton.showsMenuAsPrimaryAction = true
        buttons[.paragraph] = paragraphButton
        
        let imageGalleryButton = createButton(imageName: "photo", systemImage: true)
        imageGalleryButton.menu = setupMenu(for: .image)
        imageGalleryButton.showsMenuAsPrimaryAction = true
        buttons[.image] = imageGalleryButton
        
        let textBoxButton = createButton(imageName: "textbox", systemImage: true, objcFunc: #selector(addTextBox))
        buttons[.textBox] = textBoxButton
        
        let paintbrushButton = createButton(imageName: "paintbrush", systemImage: true, objcFunc: #selector(openEditTextContainer))
        buttons[.format] = paintbrushButton
        
        return buttons
    }
    
    internal func setupMenu(for type: BarButtonType) -> UIMenu {
        var actions = [UIAction]()
        
        switch type {
        case .list:
            actions = [
                UIAction(title: "Bullet list".localized(), image: UIImage(systemName: "list.bullet"), identifier: .init("bullet"), state: .off, handler: addList(action:)),
                UIAction(title: "Numeric list".localized(), image: UIImage(systemName: "list.number"), identifier: .init("numeric"), state: .off, handler: addList(action:))
            ]
        case .paragraph:
            actions = [
                UIAction(title: "First Header".localized(), image: UIImage(named: "h1"), identifier: .init("H1"), state: .off, handler: addHeader(action:)),
                UIAction(title: "Second Header".localized(), image: UIImage(named: "h2"), identifier: .init("H2"), state: .off, handler: addHeader(action:)),
                UIAction(title: "Third Header".localized(), image: UIImage(named: "h3"), identifier: .init("H3"), state: .off, handler: addHeader(action:)),
                UIAction(title: "Paragraph".localized(), image: UIImage(systemName: "paragraph"), identifier: .init("P"), state: .off, handler: addHeader(action:))
            ]
        case .image:
            actions = [
                UIAction(title: "Camera".localized(), image: UIImage(systemName: "camera"), identifier: .init("camera"), state: .off, handler: addImage(action:)),
                UIAction(title: "Library".localized(), image: UIImage(systemName: "photo.on.rectangle"), identifier: .init("library"), state: .off, handler: addImage(action:))
            ]
        default:
            break
        }
        
        return UIMenu(title: type.rawValue.localized(), identifier: .format, children: actions)
    }
    
    // MARK: - Action functions
    
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
     This function executes an action, using the UIAction's identifier to determine the type of list to be added.
     - Parameter action: The UIAction that will be analysed.
     */
    private func addList(action: UIAction) {
        switch action.identifier {
        case .init("bullet"):
            textView?.addList(.bullet)
        case .init("numeric"):
            textView?.addList(.numeric)
        default:
            break
        }
    }
    
    /**
     This function executes an action, using the UIAction's identifier to determine the type of paragraph style to be added.
     - Parameter action: The UIAction that will be analysed.
     */
    private func addHeader(action: UIAction) {
        guard let textView = self.textView else {
            return
        }
        
        switch action.identifier {
        case .init("H1"):
            textView.setFont(to: textView.activeFont.toStyle(.h1))
        case .init("H2"):
            textView.setFont(to: textView.activeFont.toStyle(.h2))
        case .init("H3"):
            textView.setFont(to: textView.activeFont.toStyle(.h3))
        case .init("P"):
            textView.setFont(to: textView.activeFont.toStyle(.paragraph))
        default:
            break
        }
    }
    
    private func addImage(action: UIAction) {
        switch action.identifier {
        case .init("camera"):
            observer?.presentCameraPicker()
        case .init("library"):
            observer?.presentPhotoPicker()
        default:
            break
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
}
