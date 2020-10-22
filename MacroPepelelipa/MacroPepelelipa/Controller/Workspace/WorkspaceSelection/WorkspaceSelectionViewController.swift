//
//  WorkspaceSelectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import StoreKit

internal class WorkspaceSelectionViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    private var compactRegularConstraints: [NSLayoutConstraint] = []
    private var regularCompactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource
        
        collectionView.register(
            WorkspaceCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkspaceCollectionViewCell.cellID())
        
        return collectionView
    }()
    
    private lazy var collectionDelegate = WorkspacesCollectionViewDelegate { [unowned self] (selectedCell) in
        guard let workspace = selectedCell.workspace else {
            let alertController = UIAlertController(
                title: "Could not open this workspace".localized(),
                message: "The app could not load this workspace".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The workspace cell did not have a workspace".localized())
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let notebooksSelectionView = NotebooksSelectionViewController(workspace: workspace)
        
        self.navigationController?.pushViewController(notebooksSelectionView, animated: true)
    }
    
    private lazy var collectionDataSource = WorkspacesCollectionViewDataSource(viewController: self, collectionView: { self.collectionView })
    
    private lazy var btnAdd: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTap))
        return item
    }()
    
    private lazy var emptyScreenView: EmptyScreenView = {
        let view = EmptyScreenView(
            frame: .zero,
            descriptionText: "No workspace".localized(),
            imageName: "Default-workspace",
            buttonTitle: "Create workspace".localized()) {
            self.btnAddTap()
        }
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootColor
        navigationItem.rightBarButtonItem = btnAdd
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Workspaces".localized()
        view.addSubview(collectionView)
        view.addSubview(emptyScreenView)
        
        setConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: MarkdownHeader.firstHeaderFont,
            .foregroundColor: UIColor.titleColor ?? .black
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .font: MarkdownHeader.thirdHeaderFont,
            .foregroundColor: UIColor.titleColor ?? .black
        ]

        let time = UserDefaults.standard.integer(forKey: "numberOfTimes")
        if time == 0 && collectionDataSource.isEmpty {
            createOnboarding()
        } else if time == 8 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                #if !targetEnvironment(macCatalyst)
                SKStoreReviewController.requestReview(in: scene)
                #endif
            }
        } else {
            UserDefaults.standard.setValue(time + 1, forKey: "numberOfTimes")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            updateConstraintsForIpad()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    // MARK: - Functions

    private func createOnboarding() {
        do {
            let workspace = try DataManager.shared().createWorkspace(named: "Your first workspace".localized())
            let notebook = try DataManager.shared().createNotebook(in: workspace, named: "Your first notebook".localized(), colorName: "nb0")
            let note = try DataManager.shared().createNote(in: notebook)
            note.title = NSAttributedString(string: "Welcome Note".localized())
            let parts: [NSAttributedString] = [
                "Onboard intro".localized().toNoteDefaulText(),
                "Workspaces".localized().toNoteH2Text(),
                "Workspace text".localized().toNoteDefaulText(),
                "Notebooks".localized().toNoteH2Text(),
                "Notebook text".localized().toNoteDefaulText(),
                "Note Taking".localized().toNoteH2Text(),
                "Writing".localized().toNoteH3Text(),
                "Writing text".localized().toNoteDefaulText(),
                "Floating Boxes".localized().toNoteH3Text(),
                "Floating boxes text".localized().toNoteDefaulText(),
                "Markdown".localized().toNoteH3Text(),
                "Markdown text".localized().toNoteDefaulText()
            ]
            let text = NSMutableAttributedString()
            for part in parts {
                text.append(part)
                text.append(NSAttributedString(string: "\n"))
                text.append(NSAttributedString(string: "\n"))
            }
            note.text = text
            try note.save()
        } catch {
            let alertController = UIAlertController(
                title: "Unable to create onboarding".localized(),
                message: "The app was unable to create an example workspace".localized(),
                preferredStyle: .alert).makeErrorMessage(with: "Unable to create onboarding")
            self.present(alertController, animated: true)
        }
    }
    
    private func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        for visibleCell in collectionView.visibleCells {
            if let cell = visibleCell as? WorkspaceCollectionViewCell {
                cell.invalidateLayout()
            }
        }
    }
    
    /**
     This private method sets the constraints for different size classes and devices.
     */
    private func setConstraints() {
        sharedConstraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyScreenView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyScreenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        compactRegularConstraints.append(contentsOf: [
            emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            regularCompactConstraints.append(contentsOf: [
                emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),
                emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4)
            ])
        } else {
            regularCompactConstraints.append(contentsOf: [
                emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35),
                emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35)
            ])
        }
        
        regularConstraints.append(contentsOf: [
            emptyScreenView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            emptyScreenView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25)
        ])
    }
    
    /**
     This method layouts the appropriate constraits based on the current trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            updateConstraintsForIphone(with: traitCollection)
        } else {
            updateConstraintsForIpad()
        }
    }
    
    /**
     This method updates the view's constraints for an iPhone based on a trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func updateConstraintsForIphone(with traitCollection: UITraitCollection) {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        if traitCollection.horizontalSizeClass == .compact {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
            activate.append(contentsOf: compactRegularConstraints)
        } else {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            deactivate.append(contentsOf: compactRegularConstraints[0].isActive ? compactRegularConstraints : [])
            activate.append(contentsOf: regularCompactConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
    
    /**
     This method updates the view's constraints for an iPad based on the device orientation.
     */
    private func updateConstraintsForIpad() {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        if orientation == .portrait || orientation == .portraitUpsideDown {
            deactivate.append(contentsOf: regularConstraints[0].isActive ? regularConstraints : [])
            activate.append(contentsOf: regularCompactConstraints)
        } else {
            deactivate.append(contentsOf: regularCompactConstraints[0].isActive ? regularCompactConstraints : [])
            activate.append(contentsOf: regularConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
    
    /**
     This method displays or hides the placeholder view when called.
     - Parameter sholdBeHidden: A boolean indicating if the view shold or not be hidden. It is false by default.
     */
    internal func switchEmptyScreenView(shouldBeHidden: Bool = false) {
        let alpha: CGFloat = shouldBeHidden ? 0 : 1
        emptyScreenView.isHidden = shouldBeHidden
        
        UIView.animate(withDuration: 0.5, animations: {
            self.emptyScreenView.alpha = alpha
        }, completion: { _ in
            if alpha == 0 {
                self.emptyScreenView.isHidden = true
            }
        })
    }
    
    // MARK: - IBActions functions
    
    @IBAction func btnAddTap() {
        btnAdd.isEnabled = false
        let addController = AddWorkspaceViewController(dismissHandler: {
            self.btnAdd.isEnabled = true
        })
        addController.moveTo(self)
    }
    
    /**
     This method handles the long press on a workspace, asking the user to delete it or not.
     
     - Parameter gesture: The UILongPressGestureRecognizer containing the gesture.
     */
    @IBAction func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let cell = collectionView.cellForItem(at: indexPath) as? WorkspaceCollectionViewCell,
              let workspace = cell.workspace else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "Delete Workspace confirmation".localized(),
                                                          message: "Warning".localized(),
                                                          preferredStyle: .alert).makeDeleteConfirmation(dataType: .workspace, deletionHandler: { [weak self] _ in
                                                            do {
                                                                try DataManager.shared().deleteWorkspace(workspace)
                                                            } catch {
                                                                let alertController = UIAlertController(
                                                                    title: "Could not delete this workspace".localized(),
                                                                    message: "The app could not delete the workspace".localized() + workspace.name,
                                                                    preferredStyle: .alert)
                                                                    .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                self?.present(alertController, animated: true, completion: nil)
                                                            }
                                                          })
            self?.present(deleteAlertController, animated: true, completion: nil)
        })

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = cell
            alertController.popoverPresentationController?.sourceRect = cell.frame
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
