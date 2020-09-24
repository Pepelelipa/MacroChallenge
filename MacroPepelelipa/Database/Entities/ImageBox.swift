//
//  ImageBox.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable identifier_name

internal struct ImageBox: ImageBoxEntity {
    var note: NoteEntity
    var imagePath: String
    var x: Float
    var y: Float
    var z: Float
}
