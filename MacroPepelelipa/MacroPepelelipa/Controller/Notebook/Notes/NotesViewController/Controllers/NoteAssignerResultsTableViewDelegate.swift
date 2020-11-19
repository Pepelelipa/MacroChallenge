//
//  NoteAssignerResultsTableViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class NoteAssignerResultsTableViewDelegate: NSObject,
                                                 UITableViewDelegate,
                                                 NoteAssignerResultsDataObserver {
    
    // MARK: - Variables and Constants
    
    private var didSelectCell: ((UITableViewCell) -> Void)?
    
    private var workspaces = [WorkspaceEntity]()

    // MARK: - Initializers
    
    internal init(_ didSelectCell: @escaping (UITableViewCell) -> Void) {
        self.didSelectCell = didSelectCell
    }
    
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            didSelectCell?(cell)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoteAssignerResultsCustomHeader.cellID()) as? NoteAssignerResultsCustomHeader
        view?.title.text = workspaces[section].name
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    // MARK: - NoteAssignerResultsDataObserver Functions

    func noteAssignerFilteredWorkspaces(workspaces: [WorkspaceEntity]) {
        self.workspaces = workspaces
    }
    
    
}
