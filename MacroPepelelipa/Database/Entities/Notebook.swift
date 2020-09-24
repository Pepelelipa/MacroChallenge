//
//  Notebook.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal struct Notebook: NotebookEntity {
    var workspace: WorkspaceEntity
    var color: UIColor
    var notes: [NoteEntity]
}
