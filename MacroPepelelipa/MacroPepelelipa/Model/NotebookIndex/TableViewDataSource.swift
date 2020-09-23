//
//  TableViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookIndexTableViewDataSource: NSObject, UITableViewDataSource {
    #warning("No actual data being fed to the source.")
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotebookIndexTableViewCell.cellID, for: indexPath)
            as? NotebookIndexTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
