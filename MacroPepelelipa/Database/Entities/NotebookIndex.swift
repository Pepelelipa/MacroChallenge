//
//  NotebookIndex.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 25/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal struct NotebookIndex: NotebookIndexEntity {
    var index: String
    weak var note: NoteEntity?
    var isTitle: Bool
}
