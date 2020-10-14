//
//  TextEditingContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 14/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class TextEditingContainerViewController: UIViewController {
    
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
    
    enum SlideOutState {
        case collapsed
        case rightPanelExpanded
    }
    
    // private weak var centerNavigationController: UINavigationController?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
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
    
    func addChildSidePanelController(_ sidePanelController: NotebookIndexViewController) {
        // view.addSubview(sidePanelController.view)
        view.insertSubview(sidePanelController.view, at: 0)
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
        
        sidePanelController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sidePanelController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sidePanelController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sidePanelController.view.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4),
            sidePanelController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: -view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .collapsed
                
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.9,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut, 
                     animations: {
                        self.centerViewController?.view.frame.origin.x = targetPosition
      }, completion: completion)
    }
    
    @IBAction private func presentNotebookIndex() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded,
           let notebookIndexViewController = self.rightViewController {
            addChildSidePanelController(notebookIndexViewController)
        }
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
}
