//
//  EntityObserver.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol EntityObserver: class {
    func entityDidChangeTo(_ value: ObservableEntity)
}
