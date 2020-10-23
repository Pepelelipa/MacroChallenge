//
//  ViewToPDFExtension.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 23/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

extension UIView {
    public func toPDF() -> NSData? {
        let pdfData = NSMutableData()
        let pdfMetadata = [
            kCGPDFContextCreator: "$(PRODUCT_NAME)",
            kCGPDFContextTitle: "Notebook".localized()
        ]
        
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, pdfMetadata)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        return pdfData
    }
}
