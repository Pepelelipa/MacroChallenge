//
//  MenuController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

@available(macCatalyst 14, *)
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
        case importImage = "PEPELELIPA.Macro.menus.import"
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
    
    /**
     Sets the UIMenuBuilder to correspond with the WorkspaceSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupWorkspaceMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.importImage.rawValue))
        
        builder.insertChild(MenuController.findMenu(), atStartOfMenu: .file)
        builder.insertChild(MenuController.newWorkspaceMenu(), atStartOfMenu: .file)
    }
    
    /**
     Creates a UIMenu to create a workspace.
     - Returns: The new UIMenu.
     */
    private class func newWorkspaceMenu() -> UIMenu {
        return UIMenu(title: "New workspace".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(WorkspaceMenuId.new.rawValue),
                      options: [.destructive, .displayInline],
                      children: [WorkspaceSelectionViewController.newWorspaceCommand])
    }
    
    /**
     Creates a UIMenu to start searching.
     - Returns: The new UIMenu.
     */
    private class func findMenu() -> UIMenu {
        return UIMenu(title: "Find".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(WorkspaceMenuId.find.rawValue),
                      options: [.destructive, .displayInline],
                      children: [WorkspaceSelectionViewController.findCommand])
    }
    
    // MARK: - Notebook Menu
    
    /**
     Sets the UIMenuBuilder to correspond with the NotebooksSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupNotebookMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.importImage.rawValue))
        
        builder.insertChild(MenuController.newNotebookMenu(), atStartOfMenu: .file)
    }
    
    /**
     Creates a UIMenu to create a notebook.
     - Returns: The new UIMenu.
     */
    private class func newNotebookMenu() -> UIMenu {
        return UIMenu(title: "New notebook".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NotebookMenuId.new.rawValue),
                      options: [.destructive, .displayInline],
                      children: [NotebooksSelectionViewController.newNotebookCommand])
    }
    
    // MARK: - Note Menu
    
    /**
     Sets the UIMenuBuilder to correspond with the NotesSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupNoteMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        
        builder.insertChild(MenuController.importMenu(), atStartOfMenu: .file)
        builder.insertChild(MenuController.noteMenu(), atStartOfMenu: .file)
    }
    
    /**
     Creates a UIMenu to handle notes.
     - Returns: The new UIMenu.
     */
    private class func noteMenu() -> UIMenu {
        return UIMenu(title: "Note".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NoteMenuId.note.rawValue),
                      options: [.destructive, .displayInline],
                      children: [
                        TextEditingContainerViewController.newNoteCommand,
                        TextEditingContainerViewController.deleteCommand
                      ])
    }
    
    /**
     Creates a UIMenu to handle image imports.
     - Returns: The new UIMenu.
     */
    private class func importMenu() -> UIMenu {
        return UIMenu(title: "Import".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NoteMenuId.importImage.rawValue),
                      options: [.displayInline],
                      children: [NotesViewController.importCommand])
    }
}
