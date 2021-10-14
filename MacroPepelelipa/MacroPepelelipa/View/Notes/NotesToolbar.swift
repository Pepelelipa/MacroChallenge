//
//  NotesToolbar.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 22/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotesToolbar: UIToolbar {
    
    // MARK: - Variables and Constants
    
    internal var deleteNoteTriggered: (() -> Void)?
    internal var addImageTriggered: ((UIAction.Identifier) -> Void)?
    internal var newNoteTriggered: (() -> Void)?
    
    #if targetEnvironment(macCatalyst)
    internal var shareFileTriggered: ((UIAction.Identifier) -> Void)?
    #else
    internal var shareNoteTriggered: ((UIBarButtonItem) -> Void)?
    #endif
    
    internal lazy var deleteNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, 
                                     target: self, 
                                     action: #selector(deleteNote))
        
        button.accessibilityLabel = "Delete note label".localized()
        button.accessibilityHint = "Delete note hint".localized()
        
        return button
    }()
    
    private lazy var addImageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "photo"), 
                                     style: .plain, 
                                     target: self,
                                     action: nil)
        button.accessibilityLabel = "Add image label".localized()
        button.accessibilityHint = "Add image hint".localized()
        
        let actions = [
            UIAction(title: "Camera".localized(), 
                     image: UIImage(systemName: "camera"), 
                     identifier: .init("camera"), 
                     state: .off,
                     handler: addImage(action:)),
            UIAction(title: "Library".localized(), 
                     image: UIImage(systemName: "photo.on.rectangle"), 
                     identifier: .init("library"), 
                     state: .off, 
                     handler: addImage(action:))
        ]
        
        actions[0].accessibilityLabel = "Add from camera label".localized()
        actions[0].accessibilityHint = "Add from camera hint".localized()
        actions[1].accessibilityLabel = "Add from library label".localized()
        actions[1].accessibilityHint = "Add from library hint".localized()
        
        button.menu = UIMenu(title: BarButtonType.image.rawValue, identifier: .format, children: actions)
        
        return button
    }()
    
    private lazy var newNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, 
                                     target: self, 
                                     action: #selector(newNote))
        
        button.accessibilityLabel = "New note label".localized()
        button.accessibilityHint = "New note hint".localized()
        
        return button
    }()
    
    // MARK: - Initializers
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpButtons(true)
        
        self.sizeToFit()
        self.tintColor = .actionColor
        self.barTintColor = .backgroundColor
        self.backgroundColor = .backgroundColor
        self.setShadowImage(UIImage(), forToolbarPosition: .any)
        self.isTranslucent = false
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    private func setUpButtons(_ hasNewNoteButton: Bool) {
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.items = [deleteNoteButton, flexibleSpace, addImageButton, flexibleSpace]
        } else {
            self.items = [deleteNoteButton, flexibleSpace]
        }
        
        if hasNewNoteButton {
            self.items?.append(contentsOf: [flexibleSpace, newNoteButton])
        }
    }
    
    internal func customizeButtons(with newNoteButton: Bool) {
        self.setUpButtons(newNoteButton)
    }
    
    // MARK: - IBActions Functions
    
    @IBAction private func deleteNote() {
        deleteNoteTriggered?()
    }
    
    @IBAction private func addImage(action: UIAction) {
        addImageTriggered?(action.identifier)
    }
    
    @IBAction private func shareNote(_ sender: UIBarButtonItem) {
        #if !targetEnvironment(macCatalyst)
        shareNoteTriggered?(sender)
        #endif
    }
    
    @IBAction private func newNote() {
        newNoteTriggered?()
    }
}
