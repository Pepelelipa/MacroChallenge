//
//  NoteAssignerViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import Database 
import MarkdownText

class NoteAssignerViewController: UIViewController {
    
    internal let noteName: String
    
    private let backBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Back".localized(), for: .normal)
        button.setTitleColor(UIColor.actionColor, for: .normal)
        button.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let discardBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Discard".localized(), for: .normal)
        
        button.setTitleColor(UIColor.notebookColors[23], for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var noteNameLbl: UILabel = {
        let label = UILabel()
        
        label.text = noteName
        label.font = UIFont.defaultFont.toStyle(.h1)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let saveExplanationLbl: UILabel = {
        let label = UILabel()
        
        label.text = "Save Explanation".localized()
        label.font = UIFont.defaultFont.toStyle(.paragraph)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let  selectedNotebookLbl: UILabel  = {
        let label = UILabel()
        
        label.text = "Selected Notebook".localized()
        label.font = UIFont.defaultFont.toStyle(.h3)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let  notebookView: NotebookView = {
        let notebook = NotebookView(frame: .zero, color: UIColor.notebookColors[23])
        notebook.translatesAutoresizingMaskIntoConstraints = false
        
        return notebook
    }()
    
    private let notebookNameLbl: UILabel = {
        let label = UILabel()
        
        label.text = "Caderno"
        label.font = UIFont.defaultFont.toStyle(.h3)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let workspaceNameLbl: UILabel = {
        let label = UILabel()
        
        label.text = "Coleção"
        label.font = UIFont.defaultFont.toStyle(.paragraph)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let chooseAnotherNotebookBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ChooseAnotherNotebook"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let addToNotebookBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AddToNotebook"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            backBtn.heightAnchor.constraint(equalToConstant: 10),
            
            discardBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            discardBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            discardBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            discardBtn.heightAnchor.constraint(equalToConstant: 10),
            
            noteNameLbl.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20),
            noteNameLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            noteNameLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            noteNameLbl.heightAnchor.constraint(equalToConstant: 60),
            
            saveExplanationLbl.topAnchor.constraint(equalTo: noteNameLbl.bottomAnchor, constant: 20),
            saveExplanationLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveExplanationLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveExplanationLbl.heightAnchor.constraint(equalToConstant: 40),
            
            selectedNotebookLbl.topAnchor.constraint(equalTo: saveExplanationLbl.bottomAnchor, constant: 20),
            selectedNotebookLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectedNotebookLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectedNotebookLbl.heightAnchor.constraint(equalToConstant: 40),
            
            notebookView.topAnchor.constraint(equalTo: selectedNotebookLbl.bottomAnchor, constant: 20),
            notebookView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notebookView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.325),
            notebookView.heightAnchor.constraint(equalTo: notebookView.widthAnchor, multiplier: 1.312)
            
        ] 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        addSubsViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraints)
    }
    
    init(noteName: String) {
        self.noteName = noteName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubsViews() {
        self.view.addSubview(backBtn)
        self.view.addSubview(discardBtn)
        self.view.addSubview(noteNameLbl)
        self.view.addSubview(saveExplanationLbl)
        self.view.addSubview(selectedNotebookLbl)
        self.view.addSubview(notebookView)
    }
}
