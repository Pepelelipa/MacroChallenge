//
//  NotebookIndexTableViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookIndexTableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Variables and Constants
    
    private var didSelectCell: ((NotebookIndexTableViewCell) -> Void)?
    
    // MARK: - Initializers
    
    internal init(_ didSelectCell: @escaping (NotebookIndexTableViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    // MARK: - UITableViewDelegate functions
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let notebookIndexCell = tableView.cellForRow(at: indexPath) as? NotebookIndexTableViewCell else {
            return
        }
        
        for cell in tableView.visibleCells where cell !== notebookIndexCell {
            cell.setSelected(false, animated: true)
        }
        
        didSelectCell?(notebookIndexCell)
    }
}
