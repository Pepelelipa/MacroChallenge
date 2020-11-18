//
//  NoteAssignerResultsViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database

internal class NoteAssignerResultsViewController: UIViewController,
                                                  UISearchResultsUpdating {
    
    // MARK: - Variables and Constants

    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private lazy var searchController: CustomUISearchController = {
        let searchController = CustomUISearchController(searchResultsController: nil, owner: self, placeHolder: "Search".localized())
        searchController.searchBar.scopeButtonTitles = nil
        return searchController
    }()
    
    internal weak var filterObserver: SearchBarObserver?
    internal weak var notebookReference: NotebookEntity?
    internal weak var observer: NoteAssignerNotebookObserver?
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.rootColor
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        
        tableView.register(NoteAssignerResultsTableViewCell.self, forCellReuseIdentifier: NoteAssignerResultsTableViewCell.cellID())
        tableView.register(NoteAssignerResultsCustomHeader.self, forHeaderFooterViewReuseIdentifier: NoteAssignerResultsCustomHeader.cellID())
        
        return tableView
    }()
    
    private lazy var tableViewDelegate = NoteAssignerResultsTableViewDelegate { [unowned self] selectedCell in
        if let notebookCell = selectedCell as? NoteAssignerResultsTableViewCell {
            guard let notebook = notebookCell.notebook else {
                return
            }
            self.observer?.selectedNotebook(notebook: notebook)
            self.notebookReference = notebook
        } 
    }   
    
    private lazy var tableViewDataSource = NoteAssignerResultsTableViewDataSource(viewController: self, tableView: {
        self.tableView
    })
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    // MARK: - UISearchResultsUpdating Methos
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterObserver?.filterObjects(text, filterCategory: .all)
        }
        let value = searchController.isActive && !isSearchBarEmpty
        searchController.showsSearchResultsController = false
        filterObserver?.isFiltering(value)
        tableView.reloadData()
    }
    
    // MARK: - Override Methos

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.rootColor
        self.view.addSubview(tableView)
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraints)
    }
}
