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

    private let tableView: (() -> UITableView)?
    
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
    
    internal init(viewController: UIViewController? = nil, tableView: @escaping (() -> UITableView)) {
        self.viewController = viewController
        self.tableView = tableView
        super.init()
        setFilterObserver()
    }
    
    // MARK: - UITableViewDataSource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            let currentWorkspace = workspaces[section]
            let output = filteredNotebooks.map { 
                if let workspace = try? $0.getWorkspace(), workspace === currentWorkspace {
                    return 1 
                } else {
                    return 0 
                }
            } as [Int]
            
            return output.reduce(0, +)
        } else {
            return workspaces[section].notebooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFiltering {
            let workspace = filteredWorkspaces[indexPath.section]
            let notebook = workspace.notebooks[indexPath.row]
            let cell = NoteAssignerResultsTableViewCell(notebook: notebook)
                    
            return cell
        } else {
            let workspace = workspaces[indexPath.section]
            let notebook = workspace.notebooks[indexPath.row]
            let cell = NoteAssignerResultsTableViewCell(notebook: notebook)
                    
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredWorkspaces.count
        } else {
            return workspaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return filteredWorkspaces[section].name
        } else {
            return workspaces[section].name
        }
    }
    
    // MARK: - Internal functions
    
    internal func setFilterObserver() {
        if let noteAssignerViewController = viewController as? NoteAssignerResultsViewController {
            noteAssignerViewController.filterObserver = self
        }
    }
    
    internal func setFilterWorkspace(by selectedNotebooks: [NotebookEntity]) {
        var selectedWorkspaces = [WorkspaceEntity]()
        for notebook in selectedNotebooks {
            do {
                if !selectedWorkspaces.contains(where: { 
                    $0 === (try? notebook.getWorkspace())
                }) {
                    selectedWorkspaces.append(try notebook.getWorkspace()) 
                }
            } catch {
                let alertController = UIAlertController(
                    title: "Unable to get notebooks".localized(),
                    message: "The app was unable to get the notebooks from a workspace".localized(),
                    preferredStyle: .alert).makeErrorMessage(with: "Unable to get notebooks")
                if let viewController = viewController {
                    viewController.present(alertController, animated: true)
                }
            }
        }
        filteredWorkspaces = selectedWorkspaces
    }
   
    // MARK: - FilterObserver functions
    
    func filterObjects(_ searchText: String, filterCategory: SearchResultEnum?) {
        
        guard let categoryFlag = filterCategory else {
            return
        }
        
        switch categoryFlag {
        case .all:
            filteredNotebooks = notebooks.filter({ (notebook) -> Bool in
                return notebook.name.lowercased().contains(searchText.lowercased())
            })
            setFilterWorkspace(by: filteredNotebooks)
        default: 
            filteredWorkspaces = []
            filteredNotebooks = []
        }
    }
    
    func isFiltering(_ value: Bool) {
        isFiltering = value
    }
}
