//
//  NoteWrapper.swift
//  MacroPepelelipa
//
//  Created by Pedro Farina on 12/05/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import Database

internal struct NoteWrapper {
    private var nonWeakValue: NoteEntity?
    private weak var weakValue: NoteEntity?
    private let weak: Bool

    internal init(value: NoteEntity, weak: Bool) {
        if weak {
            weakValue = value
        } else {
            nonWeakValue = value
        }
        self.weak = weak
    }

    internal func getValue() -> NoteEntity? {
        return weakValue ?? nonWeakValue
    }
    internal mutating func setValueTo(_ value: NoteEntity?) {
        if weak {
            weakValue = value
        } else {
            nonWeakValue = value
        }
    }
}
