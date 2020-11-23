//
//  ConflictHandlerObject.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 20/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database
import UIKit
import CloudKit

internal final class ConflictHandlerObject: ConflictHandler {
    
    private weak var controller: UIViewController? {
        
        let baseController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        
        if let navigationController = baseController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let presented = baseController?.presentedViewController {
            return presented
        }
        return baseController
    }
    
    internal init() {
        
    }
    
    func chooseVersion(completionHandler: @escaping (DataVersion) -> Void) {
        completionHandler(.cloud)
    }
    
    func errDidOccur(err: Error) {
        
        if let error = err as? WorkspaceError {
            workspaceErrorHandling(error: error)
        }
        
        if let error = err as? NotebookError {
            notebookErrorHandling(error: error)
        }
        
        if let error = err as? NoteError {
            noteErrorHandling(error: error)
        }
        
        if let error = err as? PersistentError {
            persistentContainerErrorHandling(error: error)
        }
        
        if let error = err as? TextBoxError {
            textBoxErrorHandling(error: error)
        }
        
        if let error = err as? ImageBoxError {
            imageBoxErrorHandling(error: error)
        }
        
        if let error = err as? CKError {
            cloudKitErrorHandling(error: error)
        }
    }
    
    private func workspaceErrorHandling(error: WorkspaceError) {
        let title: String = "Error in Workspace"

        switch error {
        case .failedToFetch:
            presentAlertController(title: title, message: "Failed to Fetch")
        case .failedToParse:
            presentAlertController(title: title, message: "Failed to Parse")
        case .workspaceWasNull:
            presentAlertController(title: title, message: "Workspace was Null")
        }
    }
    
    private func notebookErrorHandling(error: NotebookError) {
        let title: String = "Error in Notebook"
        switch error {
        case .failedToParse:
            presentAlertController(title: title, message: "Failed to Parse")
        case .notebookWasNull:
            presentAlertController(title: title, message: "Notebook was Null")
        }
    }
    
    private func noteErrorHandling(error: NoteError) {
        let title: String = "Error in Note"
        switch error {
        case .failedToParse:
            presentAlertController(title: title, message: "Failed to Parse")
        case .noteWasNull:
            presentAlertController(title: title, message: "Note was Null")
        }
    }
    
    private func persistentContainerErrorHandling(error: PersistentError) {
        let title: String = "Error in Persistent Container"
        presentAlertController(title: title, message: "ID was Null")
    }
    
    private func textBoxErrorHandling(error: TextBoxError) {
        let title: String = "Error with Text Box"
        switch error {
        case .failedToParse:
            presentAlertController(title: title, message: "Failed to Parse")
        case .textBoxWasNull:
            presentAlertController(title: title, message: "Text Box was Null")
        }
    }
    
    private func imageBoxErrorHandling(error: ImageBoxError) {
        let title: String = "Error with Image Box"
        switch error {
        case .failedToParse:
            presentAlertController(title: title, message: "Failed to Parse")
        case .imageBoxWasNull:
            presentAlertController(title: title, message: "Image Box was Null")
        }
    }
    
    private func cloudKitErrorHandling(error: CKError) {
        let title: String = "Error with Cloud Database"
        DispatchQueue.main.async { 
            let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert).makeErrorMessage(with: error.localizedDescription)
            if error.errorCode == 9 {
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in 
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: nil)
                    }
                }
                
                alertController.addAction(settingsAction)
            }
            self.controller?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func presentAlertController(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert).makeErrorMessage(with: message)
            
            self.controller?.present(alertController, animated: true, completion: nil)
        }
    }
}
