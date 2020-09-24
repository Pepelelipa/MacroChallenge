//
//  Note.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol Note {
    var notebook: Notebook { get }
    var title: NSAttributedString { get }
    var text: NSAttributedString { get }
    var images: [ImageBox] { get }
    var textBoxes: [TextBox] { get }
}
