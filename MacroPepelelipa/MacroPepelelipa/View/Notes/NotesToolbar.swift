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
    internal var addImageTriggered: ((NSObject) -> Void)?
    internal var shareNoteTriggered: ((UIBarButtonItem) -> Void)?
    internal var newNoteTriggered: (() -> Void)?
    
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
                                     action: #selector(addImage))
        
        button.accessibilityLabel = "Add image label".localized()
        button.accessibilityHint = "Add image hint".localized()
        
        return button
    }()
    
    private lazy var shareNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), 
                                     style: .plain, 
                                     target: self, 
                                     action: #selector(shareNote))
        
        button.accessibilityLabel = "Share note label".localized()
        button.accessibilityHint = "Share note hint".localized()
        
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
        
        setUpButtons()
        
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
    
    private func setUpButtons() {
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [deleteNoteButton, flexibleSpace, addImageButton, flexibleSpace, shareNoteButton, flexibleSpace, newNoteButton]
    }
    
    // MARK: - IBActions Functions
    
    @IBAction private func deleteNote() {
        deleteNoteTriggered?()
    }
    
    @IBAction private func addImage() {
        addImageTriggered?(addImageButton)
    }
    
    @IBAction private func shareNote(_ sender: UIBarButtonItem) {
        shareNoteTriggered?(sender)
    }
    
    @IBAction private func newNote() {
        newNoteTriggered?()
    }
}
