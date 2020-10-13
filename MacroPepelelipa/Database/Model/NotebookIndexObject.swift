//
//  NotebookIndexObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal struct NotebookIndexObject: NotebookIndexEntity {
    var index: String
    weak var note: NoteEntity?
    var isTitle: Bool
}
