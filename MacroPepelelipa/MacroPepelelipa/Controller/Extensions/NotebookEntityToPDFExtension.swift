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
    internal func createFullDocument() -> Data {
        var notesPDF: [Data] = []
        
        notes.forEach { (note) in
            notesPDF.append(note.createDocument())
        }
        let notebookPDF = PDFDocument()
        
        guard let firstPDF = PDFDocument(data: notesPDF[0]) else {
            return Data()
        }
        
        guard let secoundPDF = PDFDocument(data: notesPDF[1]) else {
             return Data()
        }
        
        for pages in 0 ..< firstPDF.pageCount {
            guard let page = firstPDF.page(at: pages) else {
                return Data()
            }
            notebookPDF.insert(page, at: notebookPDF.pageCount)
        }
        
        for pages2 in 0 ..< secoundPDF.pageCount {
            guard let page = secoundPDF.page(at: pages2) else {
                return Data()
            }
            notebookPDF.insert(page, at: notebookPDF.pageCount)
        }
        
        guard let data = notebookPDF.dataRepresentation() else {
            return Data()
        }
    
        return data
    }
}
