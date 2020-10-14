//
//  TextEditingContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal enum SlideOutState {
    case collapsed
    case rightPanelExpanded
}

internal class TextEditingContainerViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    private var centerViewController: NotesViewController?
    private var rightViewController: NotebookIndexViewController?
    private var currentState: SlideOutState = .collapsed
    private lazy var centerPanelExpandedOffset: CGFloat = view.frame.width * 0.6
    
    private lazy var notebookIndexButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "n.square"), 
                                   style: .plain, 
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
        
        if let centerViewController = self.centerViewController, 
           let notebook = centerViewController.notebook {
            
            rightViewController = NotebookIndexViewController(notebook: notebook)
            view.addSubview(centerViewController.view)
            addChild(centerViewController)
        
        } else {
            navigationController?.popViewController(animated: true)
        }
        
        navigationItem.rightBarButtonItem = notebookIndexButton
    }
    
    override func viewWillLayoutSubviews() {
        
        if currentState == .rightPanelExpanded,
           let rightView = self.rightViewController?.view,
           let centerView = self.centerViewController?.view {
            
            rightView.translatesAutoresizingMaskIntoConstraints = false
            
            rightView.removeConstraints([
            ])
            
            rightView.removeConstraints(rightView.constraints)
            centerPanelExpandedOffset = view.frame.width * 0.6
            
            centerView.frame.origin.x = -view.frame.width + centerPanelExpandedOffset
            
            NSLayoutConstraint.activate([
                rightView.topAnchor.constraint(equalTo: view.topAnchor),
                rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                rightView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4),
                rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    // MARK: - Functions
    
    func addChildSidePanelController(_ sidePanelController: NotebookIndexViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
        
        animateRightPanel(shouldExpand: true)
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            animateCenterPanelXPosition(
                targetPosition: -view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.rightViewController?.view.removeFromSuperview()
            }
        }
        viewDidLayoutSubviews()
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut, 
                     animations: {
                        self.centerViewController?.view.frame.origin.x = targetPosition
                        
      }, completion: completion)
    }
    
    // MARK: - IBActions functions
    
    @IBAction private func presentNotebookIndex() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded,
           let notebookIndexViewController = self.rightViewController {
            currentState = .rightPanelExpanded
            addChildSidePanelController(notebookIndexViewController)
        } else {
            currentState = .collapsed
            animateRightPanel(shouldExpand: notAlreadyExpanded)
        }
    }
    
}
