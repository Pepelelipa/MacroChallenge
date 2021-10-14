//
//  NotesPageViewObserver.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Database

internal protocol NotesPageViewObserver: AnyObject {
    func updateNotes(from notebook: NotebookEntity)
}
