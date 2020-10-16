//
//  NotesBarButtonItems.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 15/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal enum BarButtonItemType {
    case index
    case addNote
    case moreActions
}

extension UIBarButtonItem {

    /**
     This method adds a custom UIBarButtonItem according to the specified type.
     - Parameter type: A BarButtonItemType containing the desired type of the curstom UIBarButtonItem.
     - Parameter target: A AnyObject that will be the target of the curstom UIBarButtonItem.
     - Returns: The customised UIBarButtonItem.
     */
    internal convenience init(ofType: BarButtonItemType, target: AnyObject, action: Selector) {
        self.init()
        switch ofType {
        case .index:
            self.image = UIImage(systemName: "sidebar.right")
        case .addNote:
            self.image = UIImage(systemName: "plus")
        case .moreActions:
            self.image = UIImage(systemName: "ellipsis.circle")
        }
        
        self.style = .plain
        self.target = target
        self.action = action
    }
}
