//
//  NotebookIndexViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookIndexViewController: UIViewController {
    
    private let imgViewNotebook: UIImageView = UIImageView(frame: .zero)
    private var lblSubject: UILabel = UILabel(frame: .zero)
    private let tableView: UITableView = UITableView(frame: .zero)
    private let dataSource = NotebookIndexTableViewDataSource()
    
    override func viewDidLoad() {
        setupImgViewNotebook()
        setupLblSubject()
        setupTableView()
    }
    
    private func setupImgViewNotebook() {
        
        imgViewNotebook.image = UIImage(systemName: "book")
        imgViewNotebook.translatesAutoresizingMaskIntoConstraints = false 
        view.addSubview(imgViewNotebook)
        
        imgViewNotebook.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imgViewNotebook, attribute: .height, relatedBy: .equal, toItem: imgViewNotebook, attribute: .width, multiplier: (1.33), constant: 0.0),
            imgViewNotebook.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            imgViewNotebook.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imgViewNotebook.heightAnchor.constraint(equalToConstant: 230.0)
        ])
    }
    
    private func setupLblSubject() {
        
        lblSubject.text = "Subject".localized()
        lblSubject.textAlignment = .center
        lblSubject.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblSubject)
        
        NSLayoutConstraint.activate([
            lblSubject.topAnchor.constraint(equalTo: imgViewNotebook.bottomAnchor, constant: 20),
            lblSubject.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lblSubject.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lblSubject.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func setupTableView() {
        
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.register(NotebookIndexTableViewCell.self, forCellReuseIdentifier: NotebookIndexTableViewCell.cellID)
        
        tableView.backgroundColor = view.backgroundColor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lblSubject.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
