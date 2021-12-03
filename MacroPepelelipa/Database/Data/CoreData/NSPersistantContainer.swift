//
//  NSPersistantContainer.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {

    override open class func defaultDirectoryURL() -> URL {
        return super.defaultDirectoryURL()
    }

}
