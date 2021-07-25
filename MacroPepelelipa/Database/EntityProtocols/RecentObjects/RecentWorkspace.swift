//
//  RecentWorkspace.swift
//  Database
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

public protocol RecentWorkspace {
    var name: String { get }
    var notebooks: [RecentNotebook] { get }
}
