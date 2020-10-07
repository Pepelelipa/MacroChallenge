//
//  NotebookIndexEntity.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 25/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol NotebookIndexEntity {
    var index: String { get }
    var note: NoteEntity? { get }
    var isTitle: Bool { get }

    func save() throws
}
