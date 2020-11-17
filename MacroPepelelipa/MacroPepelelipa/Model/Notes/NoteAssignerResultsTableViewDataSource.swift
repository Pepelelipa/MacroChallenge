//
//  NoteAssignerResultsTableViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class NoteAssignerResultsTableViewDataSource: NSObject,
                                                       UITableViewDataSource,
                                                       SearchBarObserver {
    
    // MARK: - Variables and Constants

    internal var isEmpty: Bool {
        return workspaces.isEmpty
    }
    
    private var filteredWorkspaces = [WorkspaceEntity]()
    private var filteredNotebooks = [NotebookEntity]()
    private var isFiltering: Bool = false

//    private let tableView: (() -> UITableView)?
    
    private weak var viewController: UIViewController?
    
    private lazy var workspaces: [WorkspaceEntity] = {
        do {
            let workspaces = try Database.DataManager.shared().fetchWorkspaces()
            return workspaces
        } catch {
            let alertController = UIAlertController(
                title: "Error fetching the workspaces".localized(),
                message: "The database could not fetch the workspace".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The Workspaces could not be fetched".localized())
            if let viewController = viewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
            return []
        }
    }()
    
    private lazy var notebooks: [NotebookEntity] = {
        var notebooksArray = [NotebookEntity]()
        
        self.workspaces.forEach { (workspace) in
            notebooksArray.append(contentsOf: workspace.notebooks)
        }
        return notebooksArray
    }()

    // MARK: - Initializers
    
    internal init(viewController: UIViewController? = nil) {
        self.viewController = viewController
//        self.tableView = tableView
        super.init()
        setFilterWorkspaceObserver()
    }
    
    // MARK: - UITableViewDataSource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workspaces[section].notebooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let workspace = workspaces[indexPath.section]
        let notebook = workspace.notebooks[indexPath.row]
        let cell = NoteAssignerResultsTableViewCell(notebook: notebook)
                
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workspaces.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return workspaces[section].name
    }
    
    // MARK: - Internal functions
    
    internal func setFilterWorkspaceObserver() {
        if let workspaceSelectionController = viewController as? WorkspaceSelectionViewController {
            workspaceSelectionController.filterObserver = self
        }
    }
   
    // MARK: - FilterObserver functions
    
    func filterObjects(_ searchText: String, filterCategory: SearchResultEnum?) {
        
        guard let categoryFlag = filterCategory else {
            return
        }
        
        switch categoryFlag {
        case .all:
            filteredWorkspaces = workspaces.filter({ (workspace) -> Bool in
                return workspace.name.lowercased().contains(searchText.lowercased())
            })
            filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
                return notebook.name.lowercased().contains(searchText.lowercased())
            })
        case .workspaces:
            filteredWorkspaces = workspaces.filter({ (workspace) -> Bool in
                return workspace.name.lowercased().contains(searchText.lowercased())
            })
            filteredNotebooks = []
        case .notebook: 
            filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
                return notebook.name.lowercased().contains(searchText.lowercased())
            })
            filteredWorkspaces = []
        }
    }
    
    func isFiltering(_ value: Bool) {
        isFiltering = value
    }
}
