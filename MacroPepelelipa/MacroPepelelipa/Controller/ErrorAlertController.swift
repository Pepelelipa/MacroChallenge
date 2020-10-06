//
//  ErrorAlertController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class ErrorAlertController: UIAlertController {

    public func setLogMessage(logMessage: String) -> UIAlertController {
        let action = UIAlertAction(title: "Done".localized(), style: .default) { _ in
            NSLog(logMessage)
        }
        
        self.view.tintColor = UIColor.actionColor
        self.addAction(action)
        
        return self
    }
    
}
