//
//  TextBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

public protocol TextBoxEntity: class {
    var text: NSAttributedString { get set }
    var width: Float { get set }
    var height: Float { get set }
    var x: Float { get set }
    var y: Float { get set }
    var z: Float { get set }

    func getNote() throws -> NoteEntity
}
