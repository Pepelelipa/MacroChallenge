//
//  FilterWorkspaceObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import Database

internal protocol FilterObserver: class {
    
    /**
    This method communicates the Data Source, from the UICollectionView, which text is inserted in the search bar and the type of the search category.
     - Parameter searchText: The text entered in the search bar.
     - Parameter filterCategory: The type of object to be fetched.
     */
    func filterObjects(_ searchText: String, filterCategory: SearchResultEnum?)
    
    func isFiltering(_ value: Bool)
}
