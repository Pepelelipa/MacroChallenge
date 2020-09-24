//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public protocol NotebookEntity {
    var name: String { get }
    var workspace: WorkspaceEntity { get }
    var color: UIColor { get }
    var notes: [NoteEntity] { get }
}
