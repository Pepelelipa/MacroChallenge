//
//  Note.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal struct Note: NoteEntity {
    var notebook: NotebookEntity
    var title: NSAttributedString
    var text: NSAttributedString
    var images: [ImageBoxEntity]
    var textBoxes: [TextBoxEntity]
}
