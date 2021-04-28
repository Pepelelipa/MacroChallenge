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
        #if DEVELOP
        return super.defaultDirectoryURL()
        #else
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Pepelelipa")
        storeURL = storeURL?.appendingPathComponent("MacroPepelelipa")
        if let url = storeURL {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            return url
        }
        #if DEBUG
        fatalError("Not possible to access the default directory URL.")
        #else
        NSLog("Not possible to access the default directory URL for group.")
        return super.defaultDirectoryURL()
        #endif
        #endif
    }

}
