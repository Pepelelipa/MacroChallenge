//
//  WorkspaceSelectionTouchBarDelegetate.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 19/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if targetEnvironment(macCatalyst)
import UIKit
import AppKit

extension NSTouchBarItem.Identifier {
    static let search = NSTouchBarItem.Identifier("PEPELELIPA.search")
    static let add = NSTouchBarItem.Identifier("PEPELELIPA.add")
    static let edit = NSTouchBarItem.Identifier("PEPELELIPA.edit")
    static let info = NSTouchBarItem.Identifier("PEPELELIPA.info")
}

@available(OSX 10.12.2, *)
class WorkspaceSelectionTouchBarDelegate: NSObject, NSTouchBarDelegate {
    private weak var workspaceSelectionController: WorkspaceSelectionViewController?
    
    func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        
        touchBar.delegate = self
        
        touchBar.customizationIdentifier = "workspaceTouchBar"
        touchBar.defaultItemIdentifiers = [.search, .add, .edit, .info]
        
        return touchBar
      }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .search:
            let item = NSButtonTouchBarItem(identifier: identifier, title: "", image: UIImage(systemName: "magnifyingglass") ?? UIImage(), target: self, action: #selector(search))
            return item
        case .add:
            let item = NSButtonTouchBarItem(identifier: identifier, title: "", image: UIImage(systemName: "plus") ?? UIImage(), target: self, action: #selector(addWorkspace))
            return item
        case .edit:
            let item = NSButtonTouchBarItem(identifier: identifier, title: "Edit", image: UIImage(), target: self, action: #selector(editWorkspaces))
            return item
        case .info:
            let item = NSButtonTouchBarItem(identifier: identifier, title: "", image: UIImage(systemName: "info") ?? UIImage(), target: self, action: #selector(openOnboarding))
            return item
        default:
            return nil
        }
    }
    
    @objc func search() {
        workspaceSelectionController?.startSearch()
    }
    
    @objc func addWorkspace() {
        let destination = AddWorkspaceViewController()
        destination.isModalInPresentation = true
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overFullScreen
        
//        self.
    }
    
    @objc func editWorkspaces() {
        workspaceSelectionController?.setEditButtonItem()
    }
    
    @objc func openOnboarding() {
        workspaceSelectionController?.openOnboarding()
    }
}
#endif
