//
//  EntityObject.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 06/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

internal protocol EntityObject: NSObject {
    static var recordType: String { get }
    var record: CKRecord { get }
}
