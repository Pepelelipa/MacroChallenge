//
//  RecentNote.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

public protocol RecentNote {
    var title: NSAttributedString { get }
    var text: NSAttributedString { get }
    
    func getNotebook() throws -> RecentNotebook
}
