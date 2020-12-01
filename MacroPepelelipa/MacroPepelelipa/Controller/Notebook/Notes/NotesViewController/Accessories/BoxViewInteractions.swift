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

internal class BoxViewInteractions {
    
    private weak var resizeHandleReceiver: ResizeHandleReceiver?
    private weak var boxViewReceiver: BoxViewReceiver?
    private var center: Float
    
    internal init(resizeHandleReceiver: ResizeHandleReceiver, boxViewReceiver: BoxViewReceiver, center: Float) {
        self.resizeHandleReceiver = resizeHandleReceiver 
        self.boxViewReceiver = boxViewReceiver
        self.center = center
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
    internal func createTextBox(transcription: String? = nil, note: NoteEntity) {
        do {
            let textBoxEntity = try DataManager.shared().createTextBox(in: note)
            textBoxEntity.x = center
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
            let title = "Failed to create a Text Box".localized()
            let message = "Failed to create a Text Box".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
        
    }
    
    ///Creates an Image Box
    internal func createImageBox(image: UIImage?, note: NoteEntity) {
        do {
            guard let image = image else {
                let title = "Note does not exist".localized()
                let message = "Failed to load the Note".localized()
                
                ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                return
            }
            
            let path = try FileHelper.saveToFiles(image: image)
            let imageBoxEntity = try DataManager.shared().createImageBox(in: note, at: path)
            imageBoxEntity.x = center
            imageBoxEntity.y = 10
            imageBoxEntity.width = 150
            imageBoxEntity.height = 150
            
            boxViewReceiver?.addImageBox(with: imageBoxEntity)
        } catch {
            let title = "Failed to create a Image Box".localized()
            let message = "Failed to create a Image Box".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
    }
}
