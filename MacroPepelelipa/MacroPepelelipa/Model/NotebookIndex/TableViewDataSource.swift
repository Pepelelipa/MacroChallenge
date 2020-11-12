//
//  TableViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookIndexTableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Variables and Constants
    
    private weak var notebook: NotebookEntity?
    private weak var note: NoteEntity?
    private var indexes: [NotebookIndexEntity]? {
        return notebook?.indexes
    }
    
    // MARK: - Initializers

    internal init(notebook: NotebookEntity, note: NoteEntity) {
        self.notebook = notebook
        self.note = note
    }
    
    // MARK: - UITableViewDataSource functions

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexes?.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let indexes = self.indexes,
              let note = self.note else {
            return UITableViewCell()
        }
        
        let cell = NotebookIndexTableViewCell(index: indexes[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
            if indexes[indexPath.row].note === note {
                cell.setSelected(true, animated: true)
                cell.accessibilityValue = "Selected".localized()
            }
        }
        
        return cell
    }
}
