//
//  FilterWorkspaceObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database

internal protocol FilterWorkspaceObserver: class {
    func filterWorkspace(_ searchText: String)
    func isFiltering(_ value: Bool)
}
