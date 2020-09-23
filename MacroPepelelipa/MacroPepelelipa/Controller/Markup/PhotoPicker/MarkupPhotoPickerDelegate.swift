//
//  MarkupPhotoPickerDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 23/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import PhotosUI

class MarkupPhotoPickerDelegate: PHPickerViewControllerDelegate {
    
    public var photoLibraryImage: UIImage?
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { 
            for result in results {
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if image != nil {
                            if let image = image as? UIImage {
                                self.photoLibraryImage = image
                            }
                        } else if let error = error {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
