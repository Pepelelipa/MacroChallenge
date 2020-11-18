//
//  Conflict Handler.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public enum DataVersion {
    case local
    case cloud
}

public protocol ConflictHandler {
    func chooseVersion(completionHandler: @escaping (DataVersion) -> Void)
    func errDidOccur(err: Error)
}

internal struct DefaultConflictHandler: ConflictHandler {
    public func errDidOccur(err: Error) {
        #if DEBUG
        fatalError(err.localizedDescription)
        #else
        NSLog(err.localizedDescription)
        #endif
    }

    public func chooseVersion(completionHandler: @escaping (DataVersion) -> Void) {
        completionHandler(.cloud)
    }
}
