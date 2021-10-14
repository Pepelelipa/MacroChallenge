//
//  MacNotesViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 15/03/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

#if targetEnvironment(macCatalyst)
import AppKit
import UIKit

class MacNotesViewController: NotesViewController {
    
    internal static let importCommand: UICommand = {
        return UICommand(title: "Import image".localized(), image: nil, action: #selector(importImage), propertyList: nil, alternates: [], discoverabilityTitle: "Import image".localized())
    }()
    
    private lazy var documentPickerDelegate: DocumentPickerDelegate = {
        return DocumentPickerDelegate { image in
            self.addMedia(from: image)
        }
    }()
    
    @objc internal override func importImage() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPicker.delegate = documentPickerDelegate
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .automatic
        present(documentPicker, animated: true, completion: nil)
    }
    
    /**
     This method exports an PDF from Data and a title.
     - Parameter pdfData: The data to be writen into PDF.
     - Parameter title: The file title.
     */
    private func exportPDF(_ pdfData: Data, title: String) {
        let fileManager = FileManager.default
        
        do {
            let fileURL = fileManager.temporaryDirectory.appendingPathComponent("\(title).pdf")
            try pdfData.write(to: fileURL)
            
            let controller = UIDocumentPickerViewController(forExporting: [fileURL])
            present(controller, animated: true)
        } catch {
            let title = "An error has occurred while exporting the PDF".localized()
            let message = "The app could not export the file as a PDF".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
    }
}
#endif
