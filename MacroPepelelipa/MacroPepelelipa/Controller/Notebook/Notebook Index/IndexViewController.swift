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
    internal private(set) var notebook: NotebookEntity?
    internal init(notebook: NotebookEntity) {
        self.notebook = notebook

        imgViewNotebook.tintColor = UIColor(cgColor: notebook.color)
        lblSubject.text = notebook.name
        dataSource = NotebookIndexTableViewDataSource(notebook: notebook)
        
        super.init(nibName: nil, bundle: nil)
    }

    internal required convenience init?(coder: NSCoder) {
        guard let notebook = coder.decodeObject(forKey: "notebook") as? NotebookEntity else {
            return nil
        }
        self.init(notebook: notebook)
    }

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
        lbl.textAlignment = .left
        lbl.font = lbl.font.withSize(26)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    private let dataSource: NotebookIndexTableViewDataSource
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()

        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    internal weak var delegate: NotebookIndexDelegate?

    @IBAction func btnBackTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }
    
    @IBAction func shareButtonTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "Background")
        
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
            imgViewNotebook.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: lblSubject, attribute: .centerY, relatedBy: .equal, toItem: imgViewNotebook, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            lblSubject.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
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
