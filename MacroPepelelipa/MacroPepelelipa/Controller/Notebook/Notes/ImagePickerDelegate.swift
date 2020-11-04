//
//  ImagePickerDelegate.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 29/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if !targetEnvironment(macCatalyst)

import UIKit

internal class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    // MARK: - Variables and Constants
    
    private var selectedImage: ((UIImage?) -> Void)?
    
    // MARK: - Initializers
    
    init(_ selectedImage: @escaping (UIImage?) -> Void) {
        self.selectedImage = selectedImage
    }
    
    // MARK: - ImagePickerDelegate functions
    
    /**
     With this function, we access the image that the user selected from their galary or took a photo of.
     - Parameter picker: UIImagePickerController;
     - Parameter info: the key from our Controller (UIIMagePickerController.InfoKey).
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage?(originalImage)
    }
}

#endif
