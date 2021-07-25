//
//  RecentNotebook.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

public protocol RecentNotebook {
    var name: String { get }
    var colorName: String { get }
    var notes: [RecentNote] { get }
    var lastAccess: Date? { get }
    
    func getWorkspace() throws -> RecentWorkspace
}
