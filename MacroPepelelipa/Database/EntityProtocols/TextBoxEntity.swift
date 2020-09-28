//
//  TextBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

public protocol TextBoxEntity {
    var note: NoteEntity { get }
    var text: NSAttributedString { get }
    var x: Float { get }
    var y: Float { get }
    var z: Float { get }
}
