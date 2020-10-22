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
    
    private lazy var deleteNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, 
                                     target: self, 
                                     action: #selector(deleteNote))
        return button
    }()
    
    private lazy var addImageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "photo"), 
                                     style: .plain, 
                                     target: self, 
                                     action: #selector(addImage))
        return button
    }()
    
    private lazy var shareNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), 
                                     style: .plain, 
                                     target: self, 
                                     action: #selector(shareNote))
        return button
    }()
    
    private lazy var newNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, 
                                     target: self, 
                                     action: #selector(newNote))
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
        
    }
    
    @IBAction private func addImage() {
        
    }
    
    @IBAction private func shareNote() {
        
    }
    
    @IBAction private func newNote() {
        
    }
}
