//
//  NoteAssignerNotebookObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 16/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database

protocol NoteAssignerNotebookObserver: class {
    func selectedNotebook(notebook: NotebookEntity) 
}
