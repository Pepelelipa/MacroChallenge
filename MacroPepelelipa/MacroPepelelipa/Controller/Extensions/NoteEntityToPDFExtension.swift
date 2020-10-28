//
//  NoteEntityToPDFExtension.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 23/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PDFKit

public extension NoteEntity {
    /**
     In this method, we create the PDF document that will be exported, with its correct parameters.
     - Returns: The Data that was constructed for the PDF.
     */
    internal func createDocument() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Purple Notebook".localized(),
            kCGPDFContextAuthor: "PEPELELIPA.Macro",
            kCGPDFContextTitle: title
        ] as [CFString : Any]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let titleBottom = addTitle(pageRect: pageRect)
            addBodyText(pageRect: pageRect, textTop: titleBottom + 36.0)
        }
        
        return data
    }
    
    /**
     In this method, we position the title so that it's in the correct position inside of our PDF document.
     - Returns: the CGFloat for where the title will be positioned in the document.
     */
    internal func addTitle(pageRect: CGRect) -> CGFloat {
        
        let attributedTitle = title
        
        let titleStringSize = attributedTitle.size()
        
        let titleStringRect = CGRect(
            x: 36,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        
        attributedTitle.draw(in: titleStringRect)
        
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    /**
     In this method, we position the text so that it's in the correct position inside of our PDF document.
     - Returns: the CGFloat for where the text will be positioned in the document.
     */
    internal func addBodyText(pageRect: CGRect, textTop: CGFloat) {
        let attributedText = text
        
        let textRect = CGRect(
            x: 36,
            y: textTop,
            width: pageRect.width - 20,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        attributedText.draw(in: textRect)
    }
    
}
