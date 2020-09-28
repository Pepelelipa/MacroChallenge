//
//  TextBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal struct TextBox: TextBoxEntity {
    var note: NoteEntity
    var text: NSAttributedString
    var x: Float
    var y: Float
    var z: Float
}
