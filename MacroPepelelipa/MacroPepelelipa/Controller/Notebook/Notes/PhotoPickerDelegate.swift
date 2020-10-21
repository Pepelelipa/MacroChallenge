//
//  PhotoPickerDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 20/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if !targetEnvironment(macCatalyst)

import UIKit
import PhotosUI

internal class PhotoPickerDelegate: NSObject, PHPickerViewControllerDelegate {
    
    // MARK: - Variables and Constants
    
    private var didFinishPickingResults: (([PHPickerResult]) -> Void)?
    
    // MARK: - Initializers
    
    internal init(_ didFinishPickingResults: @escaping ([PHPickerResult]) -> Void) {
        self.didFinishPickingResults = didFinishPickingResults 
    }
    
    // MARK: - PHPickerViewControllerDelegate functions
    
    internal func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        didFinishPickingResults?(results)
    }
}

#endif
