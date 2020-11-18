//
//  WorkspaceCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksCollectionViewDataSource: NSObject, 
                                                  UICollectionViewDataSource, 
                                                  EntityObserver {
    
    // MARK: - Variables and Constants
    
    private var notebooks: [NotebookEntity]
    private weak var viewController: UIViewController?
    private let collectionView: (() -> UICollectionView)?
    
    // MARK: - Initializers
    
    internal init(notebooks: [NotebookEntity], viewController: UIViewController?, collectionView: (() -> UICollectionView)?) {
        self.notebooks = notebooks
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()

        DataManager.shared().addCreationObserver(self, type: .notebook)
        for notebook in notebooks {
            notebook.addObserver(self)
        }
    }

    deinit {
        for notebook in notebooks {
            notebook.removeObserver(self)
        }
    }

    // MARK: Functions

    internal func isEmpty() -> Bool {
        return notebooks.isEmpty
    }
    
    // MARK: - UICollectionViewDataSource functions

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewController = viewController as? NotebooksSelectionViewController {
            if notebooks.isEmpty {
                viewController.switchEmptyScreenView()
            } else {
                viewController.switchEmptyScreenView(shouldBeHidden: true)
            }
        }
        return notebooks.count
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NotebookCollectionViewCell.cellID(), for: indexPath)
                as? NotebookCollectionViewCell else {
            let alertController = UIAlertController(
                title: "Error presenting a notebook".localized(),
                message: "The app could not present a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook cell could not be loaded in a workspace".localized())
            
            viewController?.present(alertController, animated: true, completion: nil)    
            return UICollectionViewCell()
        }
        let notebook = notebooks[indexPath.row]
        cell.setNotebook(notebook)
        cell.isEditing = collectionView.isEditing
        if let editableCollection = collectionView as? EditableCollectionView {
            cell.entityShouldBeDeleted = editableCollection.entityShouldBeDeleted
        }

        return cell
    }
    
    // MARK: - EntityObserver functions
    
    internal func entityWasCreated(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity {
            notebook.addObserver(self)
            notebooks.append(notebook)
            self.collectionView?().insertItems(at: [IndexPath(item: notebooks.count - 1, section: 0)])
        }
    }
    
    internal func entityDidChangeTo(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity,
           let index = notebooks.firstIndex(where: { $0 === notebook }) {
            self.collectionView?().reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    internal func entityShouldDelete(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity,
           let index = notebooks.firstIndex(where: { $0 === notebook }) {
            notebook.removeObserver(self)
            notebooks.remove(at: index)
            self.collectionView?().deleteItems(at: [IndexPath(item: index, section: 0)])
        }

        guard let viewController = viewController as? NotebooksSelectionViewController else {
            return
        }
        if notebooks.isEmpty {
            viewController.switchEmptyScreenView()
        }
    }
}
