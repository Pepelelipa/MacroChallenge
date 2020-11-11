//
//  CoreData-CloudKit Operators.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

extension Workspace {
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
    static func == (lhs: Note, rhs: CloudKitNote) -> Bool {
        let nsTitle: NSData?
        if let title = lhs.title {
            nsTitle = NSData(data: title)
        } else {
            nsTitle = nil
        }
        let title = nsTitle == rhs.title.value

        let nsText: NSData?
        if let text = lhs.text {
            nsText = NSData(data: text)
        } else {
            nsText = nil
        }
        let text = nsText == rhs.title.value

        return title && text
    }
    static func === (lhs: Note, rhs: CloudKitNote) -> Bool {
        return lhs.id?.uuidString == rhs.id.value
    }
}

extension CloudKitNote {
    static func == (lhs: CloudKitNote, rhs: Note) -> Bool {
        let nsTitle: NSData?
        if let title = rhs.title {
            nsTitle = NSData(data: title)
        } else {
            nsTitle = nil
        }
        let title = lhs.title.value == nsTitle

        let nsText: NSData?
        if let text = rhs.text {
            nsText = NSData(data: text)
        } else {
            nsText = nil
        }
        let text = lhs.title.value == nsText

        return title && text
    }
    static func === (lhs: CloudKitNote, rhs: Note) -> Bool {
        return lhs.id.value == rhs.id?.uuidString
    }
}

extension TextBox {
    static func == (lhs: TextBox, rhs: CloudKitTextBox) -> Bool {
        let nsText: NSData?
        if let text = lhs.text {
            nsText = NSData(data: text)
        } else {
            nsText = nil
        }
        let text = nsText == rhs.text.value

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
    static func == (lhs: CloudKitTextBox, rhs: TextBox) -> Bool {
        let nsText: NSData?
        if let text = rhs.text {
            nsText = NSData(data: text)
        } else {
            nsText = nil
        }
        let text = lhs.text.value == nsText

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
