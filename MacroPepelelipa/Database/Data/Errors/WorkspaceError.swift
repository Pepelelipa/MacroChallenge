//
//  WorkspaceError.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public enum WorkspaceError: Error {
    case workspaceWasNull
    case failedToParse
    case failedToFetch
}
