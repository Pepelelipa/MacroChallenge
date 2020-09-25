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

    internal init(notebook: NotebookEntity) {
        self.notebook = notebook
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook?.indexes.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotebookIndexTableViewCell.cellID, for: indexPath)
            as? NotebookIndexTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
