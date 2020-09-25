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
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)

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
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()
    private let dataSource: NotebookIndexTableViewDataSource
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()

        tableView.backgroundColor = view.backgroundColor

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    public weak var delegate: NotebookIndexDelegate?

    @IBAction func btnBackTap(_ sender: UIButton) {
        delegate?.indexShouldDismiss()
    }

    override func viewDidLoad() {
        view.addSubview(btnBack)
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
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imgViewNotebook, attribute: .height, relatedBy: .equal, toItem: imgViewNotebook, attribute: .width, multiplier: (1.33), constant: 0.0),
            imgViewNotebook.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            imgViewNotebook.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imgViewNotebook.heightAnchor.constraint(equalToConstant: 230.0)
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
