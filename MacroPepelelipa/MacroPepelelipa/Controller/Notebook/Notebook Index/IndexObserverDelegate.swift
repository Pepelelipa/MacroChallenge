//
//  IndexObserverDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database

protocol IndexObserverDelegate: class {
    func indexDidChange(for note: NoteEntity)
}
