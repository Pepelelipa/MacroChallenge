//
//  AlertController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

enum DataType: String {
    case workspace = "Workspace"
    case notebook = "Notebook"
    case note = "Note"
    case textBox = "Text Box"
    case imageBox = "Image Box"
}

extension UIAlertController {

    /**
     This method adds a single action to a UIAlertController that shows a log message when clicked, also setting the view's tint color to be the app's main color.
     - Parameter logMessage: A string containing the message to be displayed in the log.
     - Returns: The customised UIAlertController.
     */
    internal func makeErrorMessage(with logMessage: String) -> UIAlertController {
        let action = UIAlertAction(title: "Done".localized(), style: .default) { _ in
            NSLog(logMessage)
        }
        
        self.addAction(action)
        self.view.tintColor = UIColor.actionColor
        
        return self
    }
    
    /**
     This method adds a delete and a cancel action to the alert controller, giving the delete action a handler.
     - Parameter deletionHandler: The optional method that will be used as the deletion handler.
     - Returns: The customised UIAlertController.
     */
    internal func makeDeleteConfirmation(dataType: DataType, deletionHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        self.addAction(UIAlertAction(title: "Delete".localized() + " " + dataType.rawValue.localized(), style: .destructive, handler: deletionHandler))
        self.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        self.view.tintColor = UIColor.actionColor
        
        return self
    }
}
