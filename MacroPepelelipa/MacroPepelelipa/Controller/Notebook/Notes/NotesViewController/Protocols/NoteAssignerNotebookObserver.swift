//
//  NoteAssignerNotebookObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 16/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

protocol NoteAssignerNotebookObserver: AnyObject {
    /**
     Pass the chosen notebook     
     - Parameters
        - notebook: The selected Notebook.
     */
    func selectedNotebook(notebook: NotebookEntity, controller: UIViewController?) 
}
