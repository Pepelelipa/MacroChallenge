//
//  CustomUISearchController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 26/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class CustomUISearchController: UISearchController {
    
    internal init(searchResultsController: UIViewController?, owner: UISearchResultsUpdating, placeHolder: String) {
        super.init(searchResultsController: searchResultsController)
        
        self.searchResultsUpdater = owner
        self.searchBar.sizeToFit()
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.placeholder = placeHolder
        self.searchBar.scopeButtonTitles = SearchResultEnum.allCases.map { $0.rawValue }
    }
    
    internal required convenience  init?(coder: NSCoder) {
        guard let searchResultsController = coder.decodeObject(forKey: "searchResultsController") as? UIViewController,
              let owner = coder.decodeObject(forKey: "owner") as? UISearchResultsUpdating,
              let placeHolder = coder.decodeObject(forKey: "placeHolder") as? String else {
            return nil
        }
        self.init(searchResultsController: searchResultsController, owner: owner, placeHolder: placeHolder)
    }
}
