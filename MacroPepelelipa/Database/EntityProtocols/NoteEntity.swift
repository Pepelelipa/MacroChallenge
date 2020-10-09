//
//  Note.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol NoteEntity: class, ObservableEntity {
    var title: NSAttributedString { get set }
    var text: NSAttributedString { get set }
    var images: [ImageBoxEntity] { get }
    var textBoxes: [TextBoxEntity] { get }

    func getNotebook() throws -> NotebookEntity
}
