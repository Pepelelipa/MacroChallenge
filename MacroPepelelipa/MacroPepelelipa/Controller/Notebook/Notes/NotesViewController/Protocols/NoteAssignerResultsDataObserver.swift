//
//  NoteAssignerResultsDataObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 19/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database

protocol NoteAssignerResultsDataObserver: AnyObject {
    func noteAssignerFilteredWorkspaces(workspaces: [WorkspaceEntity])
}
