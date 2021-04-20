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
    
    internal static let exportNoteCommand: UICommand = {
        return UICommand(title: "Export note as PDF".localized(), image: nil, action: #selector(exportNote), propertyList: nil, alternates: [], discoverabilityTitle: "Export note as PDF".localized())
    }()

    internal static let exportNotebookCommand: UICommand = {
        return UICommand(title: "Export notebook as PDF".localized(),
                         image: nil,
                         action: #selector(exportNotebook),
                         propertyList: nil,
                         alternates: [],
                         discoverabilityTitle: "Export notebook as PDF".localized())
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
    
    @IBAction internal func exportNote() {
        guard let note = note else {
            return
        }
        let pdfData = note.createDocument()
        
        var title = note.title.string
        if title.isEmpty {
            var lenght = 10
            if note.text.length < 10 {
                lenght = note.text.length
            }
            title = note.text.attributedSubstring(from: NSRange(location: 0, length: lenght)).string
        }
        
        exportPDF(pdfData, title: title)
    }
    
    @IBAction internal func exportNotebook() {
        guard let notebook = notebook else {
            return
        }
        exportPDF(notebook.createFullDocument(), title: notebook.name)
    }
    
    internal func setShareButton(_ action: @escaping (UIAction.Identifier) -> Void) {
        self.customView.notesToolbar.shareFileTriggered = action
    }

}
#endif
