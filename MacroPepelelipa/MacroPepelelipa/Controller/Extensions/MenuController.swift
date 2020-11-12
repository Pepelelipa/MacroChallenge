//
//  MenuController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MenuController {
    
    // MARK: - Menu IDs
    
    private enum WorkspaceMenuId: String {
        case new = "PEPELELIPA.Macro.menus.newWorkspace"
        case find = "PEPELELIPA.Macro.menus.find"
    }
    
    private enum NotebookMenuId: String {
        case new = "PEPELELIPA.Macro.menus.newNotebook"
    }
    
    private enum NoteMenuId: String {
        case note = "PEPELELIPA.Macro.menus.note"
    }
    
    // MARK: - Init
    
    init(with builder: UIMenuBuilder) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController,
              let viewController = navigationController.visibleViewController else {
            setupWorkspaceMenu(with: builder)
            return
        }
        
        builder.remove(menu: .textSize)
        builder.remove(menu: .textColor)
        builder.remove(menu: .text)
        
        if viewController is WorkspaceSelectionViewController {
            setupWorkspaceMenu(with: builder)
        } else if viewController is NotebooksSelectionViewController {
            setupNotebookMenu(with: builder)
        } else {
            setupNoteMenu(with: builder)
        }
    }
    
    // MARK: - Workspace Menu
    
    private func setupWorkspaceMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        
        builder.insertChild(MenuController.findMenu(), atStartOfMenu: .file)
        builder.insertChild(MenuController.newWorkspaceMenu(), atStartOfMenu: .file)
    }
    
    private class func newWorkspaceMenu() -> UIMenu {
        // TODO: localize title
        return UIMenu(title: "NewWorkspaceCommandTitle".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(WorkspaceMenuId.new.rawValue),
                      options: [.destructive, .displayInline],
                      children: [WorkspaceSelectionViewController.newWorspaceCommand])
    }
    
    private class func findMenu() -> UIMenu {
        // TODO: localize title
        return UIMenu(title: "FindCommandTitle".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(WorkspaceMenuId.find.rawValue),
                      options: [.destructive, .displayInline],
                      children: [WorkspaceSelectionViewController.findCommand])
    }
    
    // MARK: - Notebook Menu
    
    private func setupNotebookMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        
        builder.insertChild(MenuController.newNotebookMenu(), atStartOfMenu: .file)
    }
    
    private class func newNotebookMenu() -> UIMenu {
        // TODO: localize title
        return UIMenu(title: "NewNotebookCommandTitle".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NotebookMenuId.new.rawValue),
                      options: [.destructive, .displayInline],
                      children: [NotebooksSelectionViewController.newNotebookCommand])
    }
    
    // MARK: - Note Menu
    
    private func setupNoteMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        
        builder.insertChild(MenuController.noteMenu(), atStartOfMenu: .file)
    }
    
    private class func noteMenu() -> UIMenu {
        // TODO: localize title
        return UIMenu(title: "NoteCommandTitle".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NoteMenuId.note.rawValue),
                      options: [.destructive, .displayInline],
                      children: [
                        TextEditingContainerViewController.newNoteCommand,
                        TextEditingContainerViewController.deleteCommand
                      ])
    }
}
