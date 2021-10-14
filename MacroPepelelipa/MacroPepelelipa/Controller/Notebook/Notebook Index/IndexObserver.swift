//
//  IndexObserver.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Database

internal protocol IndexObserver: AnyObject {
    func didChangeIndex(to note: NoteEntity)
}
