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
                                                  UISearchResultsUpdating,
                                                  UISearchBarDelegate {
    
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
    
    private lazy var tableViewDataSource = NoteAssignerResultsTableViewDataSource(viewController: self)
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private lazy var searchController: CustomUISearchController = {
        let searchController = CustomUISearchController(searchResultsController: self, owner: self, placeHolder: "Search".localized())
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterObserver?.filterObjects(text, filterCategory: .all)
        }
        let value = searchController.isActive && !isSearchBarEmpty
        searchController.showsSearchResultsController = true
        filterObserver?.isFiltering(value)
//        searchResultController.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.rootColor
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraints)
    }
}
