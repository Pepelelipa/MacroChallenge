//
//  FileHelper.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class FileHelper {
    private init() {
    }

    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    ///Get file, if exists returns path, else return nil
    public static func getFilePath(fileName: String) -> String? {
        let imagePath: URL = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: imagePath.relativePath) {
            return imagePath.relativePath
        } else {
            return nil
        }
    }

    ///Save image to files and returns its filename
    public static func saveToFiles(image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw UIImageSavingError.failedToGetPNGData
        }
        let directory = getDocumentsDirectory()

        let uniqueURL = directory.appendingPathComponent("\(UUID().uuidString).jpg")
        try data.write(to: uniqueURL)
        return uniqueURL.lastPathComponent
    }

    ///Delete image in file name
    public static func deleteImage(fileName: String) throws -> Bool {
        let imagePath: URL = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: imagePath.relativePath) {
            try FileManager.default.removeItem(at: imagePath)
        } else {
            return false
        }
        return true
    }
}

internal enum UIImageSavingError: Error {
    case failedToGetPNGData
}
