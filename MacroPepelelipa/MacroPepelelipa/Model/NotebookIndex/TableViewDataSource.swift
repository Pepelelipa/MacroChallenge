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
    private weak var notebook: NotebookEntity?
    private var indexes: [NotebookIndexEntity]? {
        return notebook?.indexes
    }

    internal init(notebook: NotebookEntity) {
        self.notebook = notebook
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexes?.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let indexes = indexes else {
            return UITableViewCell()
        }
        let cell = NotebookIndexTableViewCell(index: indexes[indexPath.row])
        return cell
    }
}
