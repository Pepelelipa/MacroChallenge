//
//  BoxViewInteractions.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class FormattingDelegate: NSObject, MarkdownToolBarObserver, MarkdownFormatViewReceiver {
    
    private weak var resizeHandleReceiver: ResizeHandleReceiver?
    private weak var boxViewReceiver: BoxViewReceiver?
    private weak var owner: UIViewController?
    private var note: NoteEntity?
    
    // TODO: set delegate
    internal var delegate: AppMarkdownTextViewDelegate?
    
    internal init(resizeHandleReceiver: ResizeHandleReceiver, boxViewReceiver: BoxViewReceiver, owner: UIViewController? = nil, note: NoteEntity?) {
        self.resizeHandleReceiver = resizeHandleReceiver 
        self.boxViewReceiver = boxViewReceiver
        self.owner = owner
        self.note = note
    }
    
    /**
     Move the box view and uptade their resize handles position.
     - Parameters
        - boxView: The Box View who will be moved.
        - vector: The new position of the box view.
     */
    internal func moveBoxView(boxView: BoxView, by vector: CGPoint) {
        boxView.center = vector
        resizeHandleReceiver?.uptadeResizeHandles()
        resizeHandleReceiver?.updateExclusionPaths()
    }
    
    ///Creates a TextBox
    internal func createTextBox(transcription: String? = nil) {
        if let owner = owner, let note = note {
            do {
                let textBoxEntity = try DataManager.shared().createTextBox(in: note)
                textBoxEntity.x = Float(owner.view.frame.width/2)
                textBoxEntity.y = 10
                textBoxEntity.height = 40
                textBoxEntity.width = 140
                if let transcriptedText = transcription {
                    textBoxEntity.text = transcriptedText.toStyle(.paragraph)
                } else {
                    textBoxEntity.text = "Text".localized().toStyle(.paragraph)
                }
                boxViewReceiver?.addTextBox(with: textBoxEntity)
            } catch {
                let alertController = UIAlertController(
                    title: "Failed to create a Text Box".localized(),
                    message: "The app could not create a Text Box".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "Failed to create a Text Box".localized())

                owner.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    ///Creates an Image Box
    internal func createImageBox(image: UIImage?) {
        if let owner = owner, let note = note {
            do {
                guard let image = image else {
                    let alertController = UIAlertController(
                        title: "Note does not exist".localized(),
                        message: "The app could not safe unwrap the view controller note".localized(),
                        preferredStyle: .alert)
                        .makeErrorMessage(with: "Failed to load the Note".localized())
                    
                    owner.present(alertController, animated: true, completion: nil)
                    return
                }
                
                let path = try FileHelper.saveToFiles(image: image)
                let imageBoxEntity = try DataManager.shared().createImageBox(in: note, at: path)
                imageBoxEntity.x = Float(owner.view.frame.width/2)
                imageBoxEntity.y = 10
                imageBoxEntity.width = 150
                imageBoxEntity.height = 150
                
                boxViewReceiver?.addImageBox(with: imageBoxEntity)
            } catch {
                let alertController = UIAlertController(
                    title: "Failed to create a Image Box".localized(),
                    message: "The app could not create a Image Box".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "Failed to create a Image Box".localized())
                
                owner.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func changeTextViewInput(isCustom: Bool) {
        (owner as? NotesViewController)?.toggleInputView(isCustom)
    }
    
    func presentPhotoPicker() {
        #if !targetEnvironment(macCatalyst)
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = photoPickerDelegate
        
        owner.present(picker, animated: true, completion: nil)
        #endif
    }
    
    func presentCameraPicker() {
        #if !targetEnvironment(macCatalyst)
        (owner as? NotesViewController)?.showImagePickerController(sourceType: .camera)
        #endif
    }
    
}
