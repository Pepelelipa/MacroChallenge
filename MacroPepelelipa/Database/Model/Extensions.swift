//
//  Extensions.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 28/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

extension NSAttributedString {
    func toData() -> Data? {
        let options: [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range, documentAttributes: options) else {
            return nil
        }

        return data
    }
}

extension Data {
    func toAttributedString() -> NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        return try? NSAttributedString(data: self,
                                       options: options,
                                       documentAttributes: nil)
    }
}
