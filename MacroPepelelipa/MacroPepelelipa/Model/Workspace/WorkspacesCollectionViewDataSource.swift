//
//  WorkspacesCollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspacesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    private var workspaces: [WorkspaceEntity] = [
        Database.Mockdata.getFullWorkspace(
            withName: "Faculdade",
            notebooksNames: ["Compiladores", "IA", "Economia"],
            notesTitles: ["Aula 1", "Aula 2", "Aula 3"]),
        Database.Mockdata.getFullWorkspace(
            withName: "Trabalho",
            notebooksNames: ["Swift", "Design Patterns", "Prototipação", "Apresentação", "Aulas"],
            notesTitles: ["Conceito básico", "Avançado", "Top"]),
        Database.Mockdata.getFullWorkspace(),
        Database.Mockdata.getFullWorkspace(),
        Database.Mockdata.getFullWorkspace()
    ]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workspaces.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WorkspaceCollectionViewCell.cellID(), for: indexPath)
                as? WorkspaceCollectionViewCell else {
            let alertController = ErrorAlertController(
                title: "Error presenting a workspace".localized(),
                message: "The app could not present a workspace".localized(),
                preferredStyle: .alert)
                .setLogMessage(logMessage: "A workspace cell could not be loaded".localized())
            
            viewController?.present(alertController, animated: true, completion: nil)
            return UICollectionViewCell()
        }
        cell.setWorkspace(workspaces[indexPath.row], viewController: viewController)
        return cell
    }
}
