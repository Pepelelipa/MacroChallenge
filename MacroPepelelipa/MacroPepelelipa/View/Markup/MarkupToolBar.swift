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

@available(iOS 14, *)
class MarkupToolBar: UIToolbar {
    
    let textView: MarkupTextView?
    weak var viewController: UIViewController?
    var pickerDelegate: MarkupPhotoPickerDelegate?
    
    init(frame: CGRect, owner: MarkupTextView, controller: UIViewController) {
        self.textView = owner
        self.viewController = controller
        super.init(frame: frame)
        
        setUpButtons()
        
        self.sizeToFit()
        self.tintColor = #colorLiteral(red: 0.7882352941, green: 0.768627451, blue: 0.8117647059, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpButtons() {
        
        let imageGalleryButton = createBarButtonItem(systemImageName: "photo", objcFunc: #selector(photoPicker))
        let textBoxButton = createBarButtonItem(systemImageName: "textbox", objcFunc: nil)
        let listButton = createBarButtonItem(systemImageName: "text.badge.plus", objcFunc: #selector(listAction))
        let paintbrushButton = createBarButtonItem(systemImageName: "paintbrush", objcFunc: nil)
        let paragraphButton = createBarButtonItem(systemImageName: "paragraph", objcFunc: #selector(headerAction))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.items = [flexible, textBoxButton, flexible, imageGalleryButton]
        for _ in 0...9 {
            self.items?.append(flexible)
        }
        self.items?.append(paintbrushButton)
        self.items?.append(flexible)
        self.items?.append(listButton)
        self.items?.append(flexible)
        self.items?.append(paragraphButton)
        self.items?.append(flexible)
    }    
    
    
    private func createBarButtonItem(systemImageName: String, objcFunc: Selector? ) -> UIBarButtonItem {
        guard let guardedObjcFunc = objcFunc else {
            return UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: nil)
        }
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: guardedObjcFunc)
        return barButtonItem
    }
    
    @objc func headerAction() {
        guard let guardedTextView = textView else {
            return
        }
        
        let attributedText = NSMutableAttributedString(attributedString: guardedTextView.attributedText)
        
        let attibutedString = NSMutableAttributedString(string: "\n#")

        attributedText.append(attibutedString)
                
        textView?.attributedText = attributedText          
    }
    
    @objc func photoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        pickerDelegate = MarkupPhotoPickerDelegate()
        
        let picker = PHPickerViewController(configuration: config)
        
        picker.delegate = pickerDelegate
        
        guard let controller = viewController else {
            return
        }
        
        controller.present(picker, animated: true, completion: nil)
    }
    
    @objc func listAction()  {
        guard let guardedTextView = textView else {
            return
        }
        
        let attributedText = NSMutableAttributedString(attributedString: guardedTextView.attributedText)
                
        let attibutedString = NSMutableAttributedString(string: "\n ● ")
        
        attributedText.append(attibutedString)
        
        textView?.attributedText = attributedText        
    }
    
    /**
    In this funcion, we deal with the toolbar button for bold text, adding bold manually.
    */
    @objc func pressBoldButton() {
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
}
