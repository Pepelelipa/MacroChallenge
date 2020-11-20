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
    
    private var workspaces: [WorkspaceEntity]
    
    private lazy var notebooks: [NotebookEntity] = {
        var notebooksArray = [NotebookEntity]()
        
        self.workspaces.forEach { (workspace) in
            notebooksArray.append(contentsOf: workspace.notebooks)
        }
        return notebooksArray
    }()
    
    internal weak var noteAssignerDataObserver: NoteAssignerResultsDataObserver?

    // MARK: - Initializers
    
    internal init(workspaces: [WorkspaceEntity], viewController: UIViewController? = nil, tableView: @escaping (() -> UITableView)) {
        self.workspaces = workspaces
        self.viewController = viewController
        self.tableView = tableView
        super.init()
        setFilterObserver()
    }
    
    // MARK: - UITableViewDataSource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            let currentWorkspace = filteredWorkspaces[section]
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
            let currentWorkspace = filteredWorkspaces[indexPath.section]
            var selectedNotebooks = [NotebookEntity]()
            let notebooks = currentWorkspace.notebooks
            
            for filteredNotebook in filteredNotebooks {
                let output = notebooks.filter({ filteredNotebook === $0 })
                selectedNotebooks.append(contentsOf: output)
            }
            
            let cell = NoteAssignerResultsTableViewCell(notebook: selectedNotebooks[indexPath.row])
                    
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
            noteAssignerDataObserver?.noteAssignerFilteredWorkspaces(workspaces: filteredWorkspaces)
            return filteredWorkspaces.count
        } else {
            noteAssignerDataObserver?.noteAssignerFilteredWorkspaces(workspaces: workspaces)
            return workspaces.count
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
