//
//  NotebookEntityToPDFExtension.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 28/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PDFKit

public extension NotebookEntity {
    /**
     In this method, we get all of the data that represents the PDF from the notes that the PDF has and we put them together to make sure that there is only one PDF being exported.
     - Returns: the Data from the PDF created for the NotebookEntity.
     */

    internal func createFullDocument() -> Data {
        var notesPDF: [Data] = []
        let notebookPDF = PDFDocument()
        
        notes.forEach { (note) in
            notesPDF.append(note.createDocument())
        }
        
        notesPDF.forEach({
            guard let pdf = PDFDocument(data: $0) else {
                return
            }
            for pages in 0 ..< pdf.pageCount {
                guard let page = pdf.page(at: pages) else {
                    return
                }
                notebookPDF.insert(page, at: notebookPDF.pageCount)
            }
        })
        
        guard let data = notebookPDF.dataRepresentation() else {
            return Data()
        }
    
        return data
    }
}
