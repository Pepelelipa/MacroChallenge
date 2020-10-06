//
//  ErrorAlertController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

extension UIAlertController {

    /**
     This method adds a single action to a UIAlertController that prints a log message when clicked, also setting the view's tint color to be the app's main color.
     
     - Parameter logMessage: A string containing the message to be displayed in the log.
     
     - Returns: The customised UIAlertController.
     */
    public func makeErrorMessage(with logMessage: String) -> UIAlertController {
        let action = UIAlertAction(title: "Done".localized(), style: .default) { _ in
            NSLog(logMessage)
        }
        
        self.addAction(action)
        self.view.tintColor = UIColor.actionColor
        
        return self
    }
    
}
