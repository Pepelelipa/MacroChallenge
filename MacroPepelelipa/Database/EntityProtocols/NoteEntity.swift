//
//  Note.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol NoteEntity: class {
    var notebook: NotebookEntity { get }
    var title: NSAttributedString { get }
    var text: NSAttributedString { get }
    var images: [ImageBoxEntity] { get }
    var textBoxes: [TextBoxEntity] { get }
}
