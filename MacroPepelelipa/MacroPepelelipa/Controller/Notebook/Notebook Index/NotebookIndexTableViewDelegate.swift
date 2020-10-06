//
//  NotebookIndexTableViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookIndexTableViewDelegate: NSObject, UITableViewDelegate {
    
    internal weak var observer: IndexObserverDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? NotebookIndexTableViewCell,
              let note = cell.indexNote else {
            return
        }
        
        observer?.indexDidChange(for: note)
    }
}
