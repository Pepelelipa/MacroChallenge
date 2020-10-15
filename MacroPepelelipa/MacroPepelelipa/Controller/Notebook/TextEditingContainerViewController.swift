//
//  TextEditingContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class TextEditingContainerViewController: UIViewController, 
                                                   IndexObserver {
    
    // MARK: - Variables and Constants
    
    private var centerViewController: NotesViewController?
    private weak var rightViewController: NotebookIndexViewController?
    
    private var movement: CGFloat?
    internal var widthConstraint: NSLayoutConstraint?
    
    private lazy var addNewNoteButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .addNote, 
                                   target: self, 
                                   action: #selector(addNewNote))
        return item
    }()
    
    private lazy var moreActionsButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .moreActions, 
                                   target: self, 
                                   action: #selector(presentMoreActions))
        return item
    }()
    
    private lazy var notebookIndexButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .index, 
                                   target: self, 
                                   action: #selector(presentNotebookIndex))
        return item
    }()
    
    // MARK: - Initializers
    
    internal init(centerViewController: NotesViewController) {
        self.centerViewController = centerViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    internal convenience required init?(coder: NSCoder) {
        guard let centerViewController = coder.decodeObject(forKey: "centerViewController") as? NotesViewController else {
            return nil
        }
        self.init(centerViewController: centerViewController)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let centerViewController = self.centerViewController {
            showCenterViewController(centerViewController)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
        navigationItem.rightBarButtonItems = [addNewNoteButton, moreActionsButton, notebookIndexButton]
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .rootColor
    }
    
    // MARK: - Functions
    
    func didChangeIndex(to note: NoteEntity) {
        if let rightViewController = rightViewController {
            hideIndex(rightViewController)
            
            do {
                let centerViewController = NotesViewController(notebook: try note.getNotebook(), note: note)
                showCenterViewController(centerViewController)
                
            } catch {
                let alertController = UIAlertController(
                    title: "Could not open this note".localized(),
                    message: "The app could not open the selected note".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "The app could not present the Notebook Index".localized())
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
     This method instaciates NotebookIndexViewController and peform an animation to show it.
     - Parameter notebook: The current notebook
     */
    private func showIndex(for notebook: NotebookEntity) {
        let rightViewController = NotebookIndexViewController(notebook: notebook)
        rightViewController.observer = self
        rightViewController.willMove(toParent: self)
        addChild(rightViewController)
        
        let rightView: UIView = rightViewController.view
        rightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightView)
        rightView.frame = CGRect(x: view.frame.maxX, y: view.frame.maxY, width: 0, height: view.frame.height)

        let widthConstraint = rightView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        self.widthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            widthConstraint,
            rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightView.topAnchor.constraint(equalTo: view.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        rightViewController.didMove(toParent: self)
        self.movement = view.frame.width * 0.4

        UIView.animate(withDuration: 0.5) {
            for child in self.view.subviews {
                child.frame.origin.x -= self.view.frame.width * 0.4
            }
        }

        self.rightViewController = rightViewController
    }
    
    /**
     This method peforms an animation to hide the NotebookIndexViewController.
     - Parameter rightViewController: the presenting NotebookIndexViewController.
     */
    private func hideIndex(_ rightViewController: NotebookIndexViewController) {
        UIView.animate(withDuration: 0.5) {
            for child in self.view.subviews {
                child.frame.origin.x += self.movement ?? rightViewController.view.frame.width
            }
        } completion: { _ in
            rightViewController.willMove(toParent: nil)
            rightViewController.removeFromParent()
            rightViewController.view.removeFromSuperview()
            rightViewController.didMove(toParent: nil)
        }

        self.rightViewController = nil
    }
    
    /**
     This method removes a NotesViewController and instaciates a new one.
     - Parameter centerViewController: The current centerViewController.
     */
    private func showCenterViewController(_ centerViewController: NotesViewController) {
        
        self.centerViewController?.willMove(toParent: nil)
        self.centerViewController?.removeFromParent()
        self.centerViewController?.view.removeFromSuperview()
        self.centerViewController?.didMove(toParent: nil)
        
        self.centerViewController = centerViewController
        centerViewController.willMove(toParent: self)
        addChild(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMove(toParent: self)
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func addNewNote() {
        guard let rootViewController = centerViewController, let guardedNotebook = rootViewController.notebook else {
            return
        }
        addNewNoteButton.isEnabled = false
        let addController = AddNoteViewController(notebook: guardedNotebook, dismissHandler: {
            self.addNewNoteButton.isEnabled = true
        })
        addController.moveTo(self)
    }
    
    @IBAction private func presentMoreActions() {
        // TODO: present more actions
    }

    /**
     This method checks if the notebook index is already appearing on screen or not. If it isn't appearing on screen, instaciates NotebookIndexViewController and peform an animation to show it. If it is appearing on screen, peform an animation to hide it.
     */
    @IBAction private func presentNotebookIndex() {
        
        if let rightViewController = rightViewController {
            hideIndex(rightViewController)
        
        } else if let notebook = centerViewController?.notebook {
            showIndex(for: notebook)
        
        } else {
            // Present error alert
            let alertController = UIAlertController(
                title: "Error presenting Notebook Index".localized(),
                message: "The app could not present the Notebook Index".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The app could not load the NotebookIndexViewController".localized())
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
