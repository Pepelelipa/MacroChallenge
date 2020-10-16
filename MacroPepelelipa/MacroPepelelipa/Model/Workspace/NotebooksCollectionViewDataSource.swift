//
//  WorkspaceCollectionViewDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebooksCollectionViewDataSource: NSObject, UICollectionViewDataSource, EntityObserver {

    func entityWasCreated(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity,
           let count = workspace?.notebooks.count {
            notebook.addObserver(self)
            self.collectionView?().insertItems(at: [IndexPath(item: count - 1, section: 0)])
        }
    }
    func entityDidChangeTo(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity,
           let index = workspace?.notebooks.firstIndex(where: { $0 === notebook }) {
            self.collectionView?().reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    func entityShouldDelete(_ value: ObservableEntity) {
        if let notebook = value as? NotebookEntity,
           let index = workspace?.notebooks.firstIndex(where: { $0 === notebook }) {
            notebook.removeObserver(self)
            self.collectionView?().deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private weak var workspace: WorkspaceEntity?
    private weak var viewController: UIViewController?
    private let collectionView: (() -> UICollectionView)?
    
    internal init(workspace: WorkspaceEntity, viewController: UIViewController?, collectionView: (() -> UICollectionView)?) {
        self.workspace = workspace
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()

        DataManager.shared().addCreationObserver(self, type: .notebook)
    }

    deinit {
        if let workspace = workspace {
            for notebook in workspace.notebooks {
                notebook.removeObserver(self)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewController = viewController as? NotebooksSelectionViewController,
           let notebooks = workspace?.notebooks {
            if notebooks.isEmpty {
                viewController.switchEmptyScreenView()
            } else {
                viewController.switchEmptyScreenView(shouldBeHidden: true)
            }
        }
        
        return workspace?.notebooks.count ?? 0
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NotebookCollectionViewCell.cellID(), for: indexPath)
                as? NotebookCollectionViewCell,
                let notebook = workspace?.notebooks[indexPath.row] else {
            let alertController = UIAlertController(
                title: "Error presenting a notebook".localized(),
                message: "The app could not present a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook cell could not be loaded in a workspace".localized())
            
            viewController?.present(alertController, animated: true, completion: nil)    
            return UICollectionViewCell()
        }
        cell.setNotebook(notebook)
        return cell
    }
}
