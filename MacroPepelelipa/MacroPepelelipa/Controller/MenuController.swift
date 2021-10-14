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
        case export = "PEPELELIPA.Macro.menus.export"
    }
    
    // MARK: - Init
    
    init(with builder: UIMenuBuilder) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController,
              let viewController = navigationController.visibleViewController as? ViewController else {
            return
        }
        
        builder.remove(menu: .textSize)
        builder.remove(menu: .textColor)
        builder.remove(menu: .text)
        
        if viewController is WorkspaceSelectionViewController {
            setupWorkspaceMenu(with: builder, viewController)
        } else if viewController is NotebooksSelectionViewController {
            setupNotebookMenu(with: builder, viewController)
        } else {
            setupNoteMenu(with: builder, viewController)
        }
    }
    
    func createMenu(title: String, id: UIMenu.Identifier, command: [UIKeyCommand]) -> UIMenu {
        return UIMenu(title: title,
                      identifier: id,
                      options: [.displayInline],
                      children: command)
    }
    
    // MARK: - Workspace Menu
    
    /**
     Sets the UIMenuBuilder to correspond with the WorkspaceSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupWorkspaceMenu(with builder: UIMenuBuilder, _ viewController: ViewController) {
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.importImage.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.export.rawValue))
        
        let commandNMenu = createMenu(title: "New workspace".localized(),
                                      id: UIMenu.Identifier(WorkspaceMenuId.new.rawValue),
                                      command: [viewController.newCommand])
        
        let commandFMenu = createMenu(title: "Find".localized(),
                                      id: UIMenu.Identifier(WorkspaceMenuId.find.rawValue),
                                      command: [viewController.findCommand])
                
        builder.insertChild(commandNMenu, atStartOfMenu: .file)
        builder.insertChild(commandFMenu, atStartOfMenu: .file)
    }
    
    // MARK: - Notebook Menu
    
    /**
     Sets the UIMenuBuilder to correspond with the NotebooksSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupNotebookMenu(with builder: UIMenuBuilder, _ viewController: ViewController) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.note.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.importImage.rawValue))
        builder.remove(menu: UIMenu.Identifier(NoteMenuId.export.rawValue))
        
        builder.insertChild(createMenu(title: "New notebook".localized(), id: UIMenu.Identifier(NotebookMenuId.new.rawValue), command: [viewController.newCommand]), atStartOfMenu: .file)
    }
    
    // MARK: - Note Menu
    
    /**
     Sets the UIMenuBuilder to correspond with the NotesSelectionViewController context.
     - Parameter builder: The UIMenuBuilder to be set.
     */
    private func setupNoteMenu(with builder: UIMenuBuilder, _ viewController: ViewController) {
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.new.rawValue))
        builder.remove(menu: UIMenu.Identifier(WorkspaceMenuId.find.rawValue))
        builder.remove(menu: UIMenu.Identifier(NotebookMenuId.new.rawValue))
        
        let commandNMenu = createMenu(title: "Note".localized(), id: UIMenu.Identifier(NoteMenuId.note.rawValue), command: [viewController.newCommand, viewController.deleteCommand])
        
        builder.insertChild(MenuController.importMenu(), atStartOfMenu: .file)
        builder.insertChild(commandNMenu, atStartOfMenu: .file)
    }
    
    /**
     Creates a UIMenu to handle image imports.
     - Returns: The new UIMenu.
     */
    private class func importMenu() -> UIMenu {
        #if targetEnvironment(macCatalyst)
        return UIMenu(title: "Import".localized(),
                      image: nil,
                      identifier: UIMenu.Identifier(NoteMenuId.importImage.rawValue),
                      options: [.displayInline],
                      children: [
                        MacNotesViewController.importCommand
                      ])
        #else
        return UIMenu()
        #endif
    }
}
