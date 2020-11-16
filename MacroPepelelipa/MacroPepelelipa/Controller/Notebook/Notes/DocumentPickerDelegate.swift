//
//  DocumentPickerViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

@available(macCatalyst 14, *)
internal class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {

    private var importHandler: (UIImage) -> Void
    
    init(importHandler: @escaping (UIImage) -> Void) {
        self.importHandler = importHandler
    }
        
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, let image = UIImage(contentsOfFile: url.path) else {
            return
        }
        
        importHandler(image)
        controller.dismiss(animated: true)
    }
    
    internal func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
