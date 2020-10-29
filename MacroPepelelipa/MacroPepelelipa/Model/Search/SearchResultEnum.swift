//
//  SearchResultEnum.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 28/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

internal enum SearchResultEnum: CaseIterable {

    case all
    case notebook
    case workspaces
    
    var rawValue: String {
        switch self {
        case .all:
            return "All"
        case .notebook:
            return "Notebooks".localized()
        case .workspaces:
            return "Workspaces".localized()
        }
    }
        
    init?(rawValue: String) {
        switch rawValue {
        case "All":
            self = .all
        case "Notebooks".localized():
            self = .notebook
        case "Workspaces".localized():
            self = .workspaces
        default:
            self = .all
        }
    }
}
