//
//  ViewToPDFExtension.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 23/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PDFKit

public extension NoteEntity {
    func createDocument() -> Data {
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
        let attributes = [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
        ]
        let text = "I'm a PDF!"
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
      }

      return data
    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
      let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
      
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
      
      let attributedTitle = NSAttributedString(
        string: title,
        attributes: titleAttributes
      )
      
      let titleStringSize = attributedTitle.size()
      
      let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: 36,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
      
      attributedTitle.draw(in: titleStringRect)
      
      return titleStringRect.origin.y + titleStringRect.size.height
    }

}
