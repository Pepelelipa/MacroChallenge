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

class NoteAssignerViewController: UIViewController, 
                                  NoteAssignerNotebookObserver {
    
    internal weak var note: NoteEntity?
    
    internal weak var observer: NoteAssignerObserver?
    
    private weak var lastNotebook: NotebookEntity? {
        didSet {
            notebookView.color = UIColor(named: lastNotebook?.colorName ?? "") ?? .black
            
            notebookNameLbl.text = lastNotebook?.name
            do {
                try workspaceNameLbl.text = lastNotebook?.getWorkspace().name
            } catch {
                let alertController = UIAlertController(
                    title: "Unable to get the last notebook".localized(),
                    message: "The app was unable to get the notebook from UserDefaults".localized(),
                    preferredStyle: .alert).makeErrorMessage(with: "Unable to get the last notebook")
               
                self.present(alertController, animated: true)
            }
        }
    }

    private let discardBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Discard".localized(), style: .plain, target: self, action: #selector(changeNotebook))
        return item
    }()
    
    private lazy var noteNameLbl: UILabel = {
        let label = UILabel()
        
        label.text = note?.title.string
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
        label.font = UIFont.defaultFont.toStyle(.h2)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notebookView: NotebookView = {
        let notebookView = NotebookView(frame: .zero)
        
        if let guardedNotebook = lastNotebook {
            notebookView.color = UIColor(named: guardedNotebook.colorName) ?? .black
        }
        notebookView.translatesAutoresizingMaskIntoConstraints = false
        
        return notebookView
    }()
    
    private lazy var notebookNameLbl: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        if let guardedNotebook = lastNotebook {
            let text = NSMutableAttributedString(attributedString: guardedNotebook.name.toStyle(.h3))
            text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
            label.attributedText = text
        }
        
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var workspaceNameLbl: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        if let guardedNotebook = lastNotebook {
            do {
                let workspace = try guardedNotebook.getWorkspace() 
                let text = NSMutableAttributedString(attributedString: workspace.name.toStyle(.paragraph))
                text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
                label.attributedText = text
            } catch {
                let alertController = UIAlertController(
                    title: "Unable to get the last notebook".localized(),
                    message: "The app was unable to get the notebook from UserDefaults".localized(),
                    preferredStyle: .alert).makeErrorMessage(with: "Unable to get the last notebook")
               
                self.present(alertController, animated: true)
            }
        }
        
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let chooseAnotherNotebookBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ChooseAnotherNotebook"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeNotebook), for: .touchUpInside)
        
        return button
    }()
    
    private let addToNotebookBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AddToNotebook"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addToNotebook), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            noteNameLbl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            noteNameLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            noteNameLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            noteNameLbl.heightAnchor.constraint(equalToConstant: 40),
            
            saveExplanationLbl.topAnchor.constraint(equalTo: noteNameLbl.bottomAnchor, constant: 20),
            saveExplanationLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveExplanationLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveExplanationLbl.heightAnchor.constraint(equalToConstant: 40),
            
            selectedNotebookLbl.topAnchor.constraint(equalTo: saveExplanationLbl.bottomAnchor, constant: 20),
            selectedNotebookLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectedNotebookLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectedNotebookLbl.heightAnchor.constraint(equalToConstant: 40),
            
            notebookView.topAnchor.constraint(equalTo: selectedNotebookLbl.bottomAnchor, constant: 14),
            notebookView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notebookView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.325),
            notebookView.heightAnchor.constraint(equalTo: notebookView.widthAnchor, multiplier: 1.312),
            
            notebookNameLbl.topAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: 20),
            notebookNameLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notebookNameLbl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            notebookNameLbl.heightAnchor.constraint(equalToConstant: 40),
            
            workspaceNameLbl.topAnchor.constraint(equalTo: notebookNameLbl.bottomAnchor, constant: 4),
            workspaceNameLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workspaceNameLbl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.325),
            workspaceNameLbl.heightAnchor.constraint(equalToConstant: 20),
            
            chooseAnotherNotebookBtn.topAnchor.constraint(equalTo: workspaceNameLbl.bottomAnchor, constant: 14),
            chooseAnotherNotebookBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            chooseAnotherNotebookBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.677),
            chooseAnotherNotebookBtn.heightAnchor.constraint(equalTo: chooseAnotherNotebookBtn.widthAnchor, multiplier: 0.1574),
            
            addToNotebookBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            addToNotebookBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addToNotebookBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.677),
            addToNotebookBtn.heightAnchor.constraint(equalTo: addToNotebookBtn.widthAnchor, multiplier: 0.1574)
        ] 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        navigationItem.rightBarButtonItems = [discardBtn]
        addSubsViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.actionColor
        self.navigationController?.navigationBar.prefersLargeTitles = false
        NSLayoutConstraint.activate(constraints)
    }
    
    init(note: NoteEntity?, lastNotebook: NotebookEntity?) {
        self.note = note
        
        super.init(nibName: nil, bundle: nil)
        
        self.lastNotebook = lastNotebook
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity, 
              let lastNotebook = coder.decodeObject(forKey: "lastNotebook") as? NotebookEntity?
        else {
            self.init(note: nil, lastNotebook: nil)
            return
        }
        self.init(note: note, lastNotebook: lastNotebook)
    }
    
    private func addSubsViews() {
        self.view.addSubview(noteNameLbl)
        self.view.addSubview(saveExplanationLbl)
        self.view.addSubview(selectedNotebookLbl)
        self.view.addSubview(notebookView)
        self.view.addSubview(notebookNameLbl)
        self.view.addSubview(workspaceNameLbl)
        self.view.addSubview(chooseAnotherNotebookBtn)
        self.view.addSubview(addToNotebookBtn)
    }
    
    internal func selectedNotebook(notebook: NotebookEntity) {
        self.lastNotebook = notebook
    }
    
    @IBAction func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discardNote() {
        let alertControlller = UIAlertController(
            title: "Delete Note confirmation".localized(),
            message: "Warning".localized(),
            preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .note) { _ in
                let deleteAlertController = UIAlertController(
                    title: "Delete Note confirmation".localized(),
                    message: "Warning".localized(),
                    preferredStyle: .alert).makeDeleteConfirmation(dataType: .note) { [unowned self] _ in
                        if let noteEntity = self.note {
                            do {
                                try DataManager.shared().deleteNote(noteEntity)
                                observer?.dismissLosseNoteViewController()
                                self.dismiss(animated: true, completion: nil)
                            } catch {
                                let alertController = UIAlertController(
                                    title: "Could not delete this note".localized(),
                                    message: "The app could not delete the note".localized() + noteEntity.title.string,
                                    preferredStyle: .alert)
                                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                }
                self.present(deleteAlertController, animated: true, completion: nil)
        }
        alertControlller.modalPresentationStyle = .popover
        self.present(alertControlller, animated: true, completion: nil)
    }
    
    @IBAction func addToNotebook() {
        if let noteEntity = note, let notebookEntity = lastNotebook{
            print("")
        }
    }
    
    @IBAction func changeNotebook() {
        let destination = NoteAssignerResultsViewController()
        destination.observer = self
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
