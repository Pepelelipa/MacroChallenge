//
//  EntityObserver.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol EntityObserver: AnyObject {
    func entityWasCreated(_ value: ObservableEntity)
    func entityDidChangeTo(_ value: ObservableEntity)
    func entityShouldDelete(_ value: ObservableEntity)
    func getEntityWithID(_ value: String) -> ObservableEntity?
}

public extension EntityObserver {
    func entityWasCreated(_ value: ObservableEntity) {}
    func entityDidChangeTo(_ value: ObservableEntity) {}
    func entityShouldDelete(_ value: ObservableEntity) {}
}
