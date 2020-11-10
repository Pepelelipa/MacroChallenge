//
//  DropInteractionDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class DropInteractionDelegate: NSObject, UIDropInteractionDelegate {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: String.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let viewController = self.viewController as? NotesViewController else {
            return
        }
        
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            guard let images = imageItems as? [UIImage] else {
                return
            }
            
            for image in images {
                #if !targetEnvironment(macCatalyst)
                    viewController.addMedia(from: image)
                #endif
                // TODO: enable drop interaction for mac 
            }
        }
        
        _ = session.loadObjects(ofClass: String.self) { textItems in
            for text in textItems {
                viewController.insertText(text)
            }
        }
    }
    
}
