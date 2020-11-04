//
//  AppDelegateExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 04/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

extension AppDelegate {
    
    internal func pushToWorkspace(workspace: WorkspaceEntity) {
        
        guard let confirmedWindow = window, 
              let navController = confirmedWindow.rootViewController as? UINavigationController else {
            return
        }
        
        let workspaceSelection = WorkspaceSelectionViewController()
        navController.viewControllers = [workspaceSelection]
        
        let notebooksSelection = NotebooksSelectionViewController(workspace: workspace)
        workspaceSelection.navigationController?.pushViewController(notebooksSelection, animated: true)
    }
    
    internal func pushToNotebook(workspace: WorkspaceEntity, notebook: NotebookEntity) {
        
        guard let confirmedWindow = window, 
              let navController = confirmedWindow.rootViewController as? UINavigationController else {
            return
        }
        
        let workspaceSelection = WorkspaceSelectionViewController()
        navController.viewControllers = [workspaceSelection]
        
        let notebooksSelection = NotebooksSelectionViewController(workspace: workspace)
        workspaceSelection.navigationController?.pushViewController(notebooksSelection, animated: true)
        
        let notebookPageViewController = NotesPageViewController(notes: notebook.notes)
        notebooksSelection.navigationController?.pushViewController(notebookPageViewController, animated: true)
    }
    
    internal func pushToNote(workspace: WorkspaceEntity, notebook: NotebookEntity, note: NoteEntity) {
        
        guard let confirmedWindow = window, 
              let navController = confirmedWindow.rootViewController as? UINavigationController else {
            return
        }
        
        let workspaceSelection = WorkspaceSelectionViewController()
        navController.viewControllers = [workspaceSelection]
        
        let notebooksSelection = NotebooksSelectionViewController(workspace: workspace)
        workspaceSelection.navigationController?.pushViewController(notebooksSelection, animated: true)
        
        let notebookPageViewController = NotesPageViewController(notes: notebook.notes)
        notebooksSelection.navigationController?.pushViewController(notebookPageViewController, animated: true)
        
        let notesViewController = NotesViewController(note: note)
        notebookPageViewController.setNotesViewControllers(for: notesViewController)
    }
}
