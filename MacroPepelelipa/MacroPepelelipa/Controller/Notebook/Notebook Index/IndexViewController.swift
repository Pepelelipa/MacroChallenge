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
    public weak var delegate: NotebookIndexDelegate?

    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)

        return btn
    }()

    @IBAction func btnBackTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }

    override func viewDidLoad() {
        setupBackButton()
        setupImgViewNotebook()
        setupLblSubject()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        delegate?.indexWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.indexWillDisappear()
    }

    private func setupBackButton() {
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnBack)

        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
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
