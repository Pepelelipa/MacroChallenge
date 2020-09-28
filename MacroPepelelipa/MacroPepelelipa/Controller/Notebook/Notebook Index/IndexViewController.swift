//
//  NotebookIndexViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotebookIndexViewController: UIViewController {

    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = UIColor(named: "Highlight")
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)

        btn.translatesAutoresizingMaskIntoConstraints = false

        return btn
    }()
    private lazy var btnShare: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        btn.tintColor = UIColor(named: "Highlight")
        btn.addTarget(self, action: #selector(shareButtonTap(_:)), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    private let imgViewNotebook: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(systemName: "book")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill

        return imgView
    }()
    private var lblSubject: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.text = "Subject".localized()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    private let dataSource = NotebookIndexTableViewDataSource()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.register(NotebookIndexTableViewCell.self, forCellReuseIdentifier: NotebookIndexTableViewCell.cellID)

        tableView.backgroundColor = view.backgroundColor

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    public weak var delegate: NotebookIndexDelegate?

    @IBAction func btnBackTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }
    
    @IBAction func shareButtonTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }

    override func viewDidLoad() {
        view.addSubview(btnBack)
        view.addSubview(btnShare)
        view.addSubview(imgViewNotebook)
        view.addSubview(lblSubject)
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        delegate?.indexWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.indexWillDisappear()
    }

    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            btnShare.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnShare.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imgViewNotebook, attribute: .height, relatedBy: .equal, toItem: imgViewNotebook, attribute: .width, multiplier: (1.33), constant: 0.0),
            imgViewNotebook.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imgViewNotebook.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            imgViewNotebook.heightAnchor.constraint(equalToConstant: 50.0)
        ])

        NSLayoutConstraint.activate([
            lblSubject.topAnchor.constraint(equalTo: imgViewNotebook.bottomAnchor, constant: 20),
            lblSubject.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lblSubject.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lblSubject.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lblSubject.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
