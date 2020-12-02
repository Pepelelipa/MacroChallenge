//
//  NotebookIndexViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookIndexViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    private var notebook: NotebookEntity?
    private let tableViewDataSource: NotebookIndexTableViewDataSource
    
    internal weak var observer: IndexObserver?
    
    private lazy var imgViewNotebook: NotebookView = {
        let imgView = NotebookView(frame: .zero)
        if let color = UIColor(named: self.notebook?.colorName ?? "") {
            imgView.color = color
        }
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private var lblSubject: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .left
        lbl.font = UIFont.defaultHeader.toStyle(.h1)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
                
        return lbl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var tableViewDelegate: NotebookIndexTableViewDelegate = NotebookIndexTableViewDelegate { [unowned self] (selectedCell)  in
        
        if let note = selectedCell.indexNote {
            self.observer?.didChangeIndex(to: note)
            self.dismiss(animated: true, completion: nil)
            
        } else {
            let title = "Could not open this note".localized()
            let message = "The index did not have a note".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
        }
    }

    private lazy var constraints: [NSLayoutConstraint] = {
        [
            imgViewNotebook.heightAnchor.constraint(equalTo: imgViewNotebook.widthAnchor, multiplier: 1.33),
            imgViewNotebook.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imgViewNotebook.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            imgViewNotebook.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),

            lblSubject.centerYAnchor.constraint(equalTo: imgViewNotebook.centerYAnchor),
            lblSubject.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblSubject.leadingAnchor.constraint(equalTo: imgViewNotebook.trailingAnchor, constant: 20),
            lblSubject.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lblSubject.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),

            tableView.topAnchor.constraint(equalTo: lblSubject.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()

    // MARK: - Initializers
    
    internal init(notebook: NotebookEntity, note: NoteEntity) {
        self.notebook = notebook
        
        lblSubject.text = notebook.name
        lblSubject.accessibilityValue = String(format: "color notebook".localized(), notebook.colorName.localized())
        
        tableViewDataSource = NotebookIndexTableViewDataSource(notebook: notebook, 
                                                               note: note)
        
        super.init(nibName: nil, bundle: nil)
    }

    internal required convenience init?(coder: NSCoder) {
        guard let notebook = coder.decodeObject(forKey: "notebook") as? NotebookEntity,
              let note = coder.decodeObject(forKey: "note") as? NoteEntity else {
            return nil
        }
        self.init(notebook: notebook, note: note)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootColor
        
        view.addSubview(imgViewNotebook)
        view.addSubview(lblSubject)
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate(constraints)
    }
}
