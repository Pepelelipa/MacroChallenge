//
//  IndexDelegateProtocol.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal protocol NotebookIndexDelegate: class {
    func indexShouldDismiss()
    func indexWillAppear()
    func indexWillDisappear()
}
