//
//  CoreData-CloudKit Operators.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit
import CloudKit

infix operator <-

extension Workspace {
    static func <- (lhs: Workspace, rhs: CloudKitWorkspace) {
        if let id = UUID(uuidString: rhs.id.value ?? "") {
            lhs.id = id
        }
        lhs.name = rhs.name.value
        lhs.isEnabled = rhs.isEnabled == 1
    }
    static func == (lhs: Workspace, rhs: CloudKitWorkspace) -> Bool {
        let name = lhs.name == rhs.name.value
        let isEnabled = lhs.isEnabled == (rhs.isEnabled == 1)

        return name && isEnabled
    }
    static func === (lhs: Workspace, rhs: CloudKitWorkspace) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitWorkspace {
    static func <- (lhs: CloudKitWorkspace, rhs: Workspace) {
        if let id = rhs.id {
            lhs.id.value = id.uuidString
        }
        lhs.name.value = rhs.name
        lhs.isEnabled.value = rhs.isEnabled ? 1 : 0
    }
    static func == (lhs: CloudKitWorkspace, rhs: Workspace) -> Bool {
        let name = lhs.name.value == rhs.name
        let isEnabled = (lhs.isEnabled == 1) == rhs.isEnabled

        return name && isEnabled
    }
    static func === (lhs: CloudKitWorkspace, rhs: Workspace) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}

extension Notebook {
    static func <- (lhs: Notebook, rhs: CloudKitNotebook) {
        if let id = UUID(uuidString: rhs.id.value ?? "") {
            lhs.id = id
        }
        lhs.name = rhs.name.value
        lhs.colorName = rhs.colorName.value
    }
    static func == (lhs: Notebook, rhs: CloudKitNotebook) -> Bool {
        let name = lhs.name == rhs.name.value
        let colorName = lhs.colorName == rhs.colorName.value
        return name && colorName
    }
    static func === (lhs: Notebook, rhs: CloudKitNotebook) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitNotebook {
    static func <- (lhs: CloudKitNotebook, rhs: Notebook) {
        if let id = rhs.id {
            lhs.id.value = id.uuidString
        }
        lhs.name.value = rhs.name
        lhs.colorName.value = rhs.colorName
    }
    static func == (lhs: CloudKitNotebook, rhs: Notebook) -> Bool {
        let name = lhs.name.value == rhs.name
        let colorName = lhs.colorName.value == rhs.colorName
        return name && colorName
    }
    static func === (lhs: CloudKitNotebook, rhs: Notebook) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}

extension Note {
    static func <- (lhs: Note, rhs: CloudKitNote) {
        if let id = UUID(uuidString: rhs.id.value ?? "") {
            lhs.id = id
        }
        lhs.title = (rhs.title.value ?? NSData()) as Data
        lhs.text = (rhs.text.value ?? NSData()) as Data
    }
    static func == (lhs: Note, rhs: CloudKitNote) -> Bool {
        let lTitle = lhs.title?.toAttributedString()
        let rTitle = (rhs.title.value as Data?)?.toAttributedString()
        let title = lTitle == rTitle

        let lText = lhs.text?.toAttributedString()
        let rText = (rhs.text.value as Data?)?.toAttributedString()
        let text = lText == rText

        return title && text
    }
    static func === (lhs: Note, rhs: CloudKitNote) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitNote {
    static func <- (lhs: CloudKitNote, rhs: Note) {
        if let id = rhs.id {
            lhs.id.value = id.uuidString
        }
        lhs.title.value = NSData(data: rhs.title ?? Data())
        lhs.text.value = NSData(data: rhs.text ?? Data())
    }
    static func == (lhs: CloudKitNote, rhs: Note) -> Bool {
        let lTitle = (lhs.title.value as Data?)?.toAttributedString()
        let rTitle = rhs.title?.toAttributedString()
        let title = lTitle == rTitle

        let lText = (lhs.text.value as Data?)?.toAttributedString()
        let rText = rhs.text?.toAttributedString()
        let text = lText == rText

        return title && text
    }
    static func === (lhs: CloudKitNote, rhs: Note) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}

extension TextBox {
    static func <- (lhs: TextBox, rhs: CloudKitTextBox) {
        if let id = UUID(uuidString: rhs.id.value ?? "") {
            lhs.id = id
        }
        lhs.text = (rhs.text.value ?? NSData()) as Data
        lhs.width = Float(rhs.width.value ?? .leastNonzeroMagnitude)
        lhs.height = Float(rhs.height.value ?? .leastNonzeroMagnitude)
        lhs.x = Float(rhs.x.value ?? .leastNonzeroMagnitude)
        lhs.y = Float(rhs.y.value ?? .leastNonzeroMagnitude)
        lhs.z = Float(rhs.z.value ?? .leastNonzeroMagnitude)
    }
    static func == (lhs: TextBox, rhs: CloudKitTextBox) -> Bool {
        let lText = lhs.text?.toAttributedString()
        let rText = (rhs.text.value as Data?)?.toAttributedString()
        let text = lText == rText

        let width = lhs.width == Float(rhs.width.value ?? .leastNonzeroMagnitude)
        let height = lhs.height == Float(rhs.height.value ?? .leastNonzeroMagnitude)
        let x = lhs.x == Float(rhs.x.value ?? .leastNonzeroMagnitude)
        let y = lhs.y == Float(rhs.y.value ?? .leastNonzeroMagnitude)
        let z = lhs.z == Float(rhs.z.value ?? .leastNonzeroMagnitude)

        return text && width && height && x && y && z
    }
    static func === (lhs: TextBox, rhs: CloudKitTextBox) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitTextBox {
    static func <- (lhs: CloudKitTextBox, rhs: TextBox) {
        if let id = rhs.id {
            lhs.id.value = id.uuidString
        }
        lhs.text.value = NSData(data: rhs.text ?? Data())
        lhs.width.value = Double(rhs.width)
        lhs.height.value = Double(rhs.height)
        lhs.x.value = Double(rhs.x)
        lhs.y.value = Double(rhs.y)
        lhs.z.value = Double(rhs.z)
    }
    static func == (lhs: CloudKitTextBox, rhs: TextBox) -> Bool {
        let lText = (lhs.text.value as Data?)?.toAttributedString()
        let rText = rhs.text?.toAttributedString()
        let text = lText == rText

        let width = Float(lhs.width.value ?? .leastNonzeroMagnitude) == rhs.width
        let height = Float(lhs.height.value ?? .leastNonzeroMagnitude) == rhs.height
        let x = Float(lhs.x.value ?? .leastNonzeroMagnitude) == rhs.x
        let y = Float(lhs.y.value ?? .leastNonzeroMagnitude) == rhs.y
        let z = Float(lhs.z.value ?? .leastNonzeroMagnitude) == rhs.z

        return text && width && height && x && y && z
    }
    static func === (lhs: CloudKitTextBox, rhs: TextBox) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}

extension ImageBox {
    static func <- (lhs: ImageBox, rhs: CloudKitImageBox) {
        if let id = UUID(uuidString: rhs.id.value ?? "") {
            lhs.id = id
        }
        if let curretImagePath = FileHelper.getFilePath(fileName: lhs.imagePath ?? "") {
            _ = try? FileHelper.deleteImage(fileName: curretImagePath)
        }
        if let ckFile = rhs.image.value,
           let ckFileURL = ckFile.fileURL,
           let data = NSData(contentsOf: ckFileURL),
           let image = UIImage(data: data as Data) {
            lhs.imagePath = try? FileHelper.saveToFiles(image: image)
        } else {
            lhs.imagePath = nil
        }
        lhs.width = Float(rhs.width.value ?? .leastNonzeroMagnitude)
        lhs.height = Float(rhs.height.value ?? .leastNonzeroMagnitude)
        lhs.x = Float(rhs.x.value ?? .leastNonzeroMagnitude)
        lhs.y = Float(rhs.y.value ?? .leastNonzeroMagnitude)
        lhs.z = Float(rhs.z.value ?? .leastNonzeroMagnitude)
    }
    static func == (lhs: ImageBox, rhs: CloudKitImageBox) -> Bool {
        let cdImage: UIImage?
        if let path = lhs.imagePath,
           let imagePath = FileHelper.getFilePath(fileName: path),
           let image = UIImage(contentsOfFile: imagePath) {
            cdImage = image
        } else {
            cdImage = nil
        }
        let ckImage: UIImage?
        if let file = rhs.image.value,
           let fileURL = file.fileURL,
           let data = NSData(contentsOf: fileURL) {
            ckImage = UIImage(data: data as Data)
        } else {
            ckImage = nil
        }

        let image = ckImage == cdImage

        let width = lhs.width == Float(rhs.width.value ?? .leastNonzeroMagnitude)
        let height = lhs.height == Float(rhs.height.value ?? .leastNonzeroMagnitude)
        let x = lhs.x == Float(rhs.x.value ?? .leastNonzeroMagnitude)
        let y = lhs.y == Float(rhs.y.value ?? .leastNonzeroMagnitude)
        let z = lhs.z == Float(rhs.z.value ?? .leastNonzeroMagnitude)

        return image && width && height && x && y && z
    }
    static func === (lhs: ImageBox, rhs: CloudKitImageBox) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitImageBox {
    static func <- (lhs: CloudKitImageBox, rhs: ImageBox) {
        if let id = rhs.id {
            lhs.id.value = id.uuidString
        }
        if let imagePath = rhs.imagePath,
            let filePath = FileHelper.getFilePath(fileName: imagePath) {
            let fileURL = URL(fileURLWithPath: filePath)
            let asset = CKAsset(fileURL: fileURL)
            lhs.image.value = asset
        } else {
            lhs.image.value = nil
        }
        lhs.width.value = Double(rhs.width)
        lhs.height.value = Double(rhs.height)
        lhs.x.value = Double(rhs.x)
        lhs.y.value = Double(rhs.y)
        lhs.z.value = Double(rhs.z)
    }
    static func == (lhs: CloudKitImageBox, rhs: ImageBox) -> Bool {
        let ckImage: UIImage?
        if let file = lhs.image.value,
           let fileURL = file.fileURL,
           let data = NSData(contentsOf: fileURL) {
            ckImage = UIImage(data: data as Data)
        } else {
            ckImage = nil
        }
        let cdImage: UIImage?
        if let path = rhs.imagePath,
           let imagePath = FileHelper.getFilePath(fileName: path),
           let image = UIImage(contentsOfFile: imagePath) {
            cdImage = image
        } else {
            cdImage = nil
        }

        let image = ckImage == cdImage

        let width = Float(lhs.width.value ?? .leastNonzeroMagnitude) == rhs.width
        let height = Float(lhs.height.value ?? .leastNonzeroMagnitude) == rhs.height
        let x = Float(lhs.x.value ?? .leastNonzeroMagnitude) == rhs.x
        let y = Float(lhs.y.value ?? .leastNonzeroMagnitude) == rhs.y
        let z = Float(lhs.z.value ?? .leastNonzeroMagnitude) == rhs.z

        return image && width && height && x && y && z
    }
    static func === (lhs: CloudKitImageBox, rhs: ImageBox) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}
