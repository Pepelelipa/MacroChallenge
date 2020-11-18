//
//  ModifiableEntity.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol ModifiableEntity: PersistentEntity {
    /// Save modifications
    /// - Throws: Throws if fails to save.
    func save() throws
}
