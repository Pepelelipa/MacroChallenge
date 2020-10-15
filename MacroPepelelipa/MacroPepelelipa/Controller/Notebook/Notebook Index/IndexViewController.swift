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
    internal weak var observer: IndexObserver?
    private let tableViewDataSource: NotebookIndexTableViewDataSource
    
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
        lbl.font = MarkdownHeader.firstHeaderFont
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var tableViewDelegate: NotebookIndexTableViewDelegate = NotebookIndexTableViewDelegate { [unowned self] (selectedCell) in
        if let note = selectedCell.indexNote {
            self.observer?.didChangeIndex(to: note)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title: "Could not open this note".localized(),
                message: "The app could not open the selected note".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The index did not have a note".localized())
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Initializers
    
    internal init(notebook: NotebookEntity) {
        self.notebook = notebook
        lblSubject.text = notebook.name
        tableViewDataSource = NotebookIndexTableViewDataSource(notebook: notebook)
        
        super.init(nibName: nil, bundle: nil)
    }
    /**
     This method handles the press on the share button, asking the user what to do with the notebook.
     
     - Parameter sender: The UIButton that sends the action.
     */
    @IBAction func shareButtonTap(_ sender: UIButton) {
        guard let notebook = self.notebook else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .notebook, deletionHandler: { _ in
            do {
                _ = try DataManager.shared().deleteNotebook(notebook)
            } catch {
                let alertController = UIAlertController(
                    title: "Could not delete this notebook".localized(),
                    message: "The app could not delete the notebook".localized() + notebook.name,
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
    }

    internal convenience required init?(coder: NSCoder) {
        guard let notebook = coder.decodeObject(forKey: "notebook") as? NotebookEntity else {
            return nil
        }
        self.init(notebook: notebook)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootColor
        
        view.addSubview(imgViewNotebook)
        view.addSubview(lblSubject)
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillLayoutSubviews() {

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imgViewNotebook, attribute: .height, relatedBy: .equal, toItem: imgViewNotebook, attribute: .width, multiplier: (1.33), constant: 0.0),
            imgViewNotebook.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imgViewNotebook.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            imgViewNotebook.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: lblSubject, attribute: .centerY, relatedBy: .equal, toItem: imgViewNotebook, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            lblSubject.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblSubject.leadingAnchor.constraint(equalTo: imgViewNotebook.trailingAnchor, constant: 20),
            lblSubject.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lblSubject.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lblSubject.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
