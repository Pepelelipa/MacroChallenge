//
//  UIImageExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
internal extension UIImage {
    ///Save image to files and returns its path
    func saveToFiles() throws -> String {
        guard let data = pngData() else {
            throw UIImageSavingError.failedToGetPNGData
        }
        let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        let uniqueURL = directory.appendingPathComponent("\(UUID().uuidString).png")
        try data.write(to: uniqueURL)
        return uniqueURL.path
    }
}

internal enum UIImageSavingError: Error {
    case failedToGetPNGData
}
