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
    
    internal init(searchResultsController: UIViewController, owner: UISearchResultsUpdating, placeHolder: String) {
        super.init(searchResultsController: searchResultsController)
        
        self.searchResultsUpdater = owner
        self.searchBar.sizeToFit()
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.placeholder = placeHolder

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
