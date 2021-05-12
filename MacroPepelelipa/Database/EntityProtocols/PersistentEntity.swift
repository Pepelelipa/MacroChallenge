//
//  PersistentEntity.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol PersistentEntity: AnyObject {
    func getID() throws -> UUID
}
