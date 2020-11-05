//
//  ObservableEntity.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol ObservableEntity: ModifiableEntity {
    func getID() throws -> UUID
    func addObserver(_ observer: EntityObserver)
    func removeObserver(_ observer: EntityObserver)
}
