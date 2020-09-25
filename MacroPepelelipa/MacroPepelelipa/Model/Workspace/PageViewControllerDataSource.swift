//
//  WorkspacePageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class WorkspacePageControllerDataSource: NSObject, UIPageViewControllerDataSource {
    #warning("Workspace Data Source is mocked up.")
    internal private(set) var workspaces: [WorkspaceViewController] =
        [WorkspaceViewController(workspace: Database.Mockdata.getWorkspace(
                                    withName: "Faculdade",
                                    notebooksNames: ["Compiladores", "IA", "Economia"],
                                    notesTitles: ["Aula 1", "Aula 2", "Aula 3"])),
         WorkspaceViewController(workspace: Database.Mockdata.getWorkspace(
                                    withName: "Trabalho",
                                    notebooksNames: ["Swift", "Design Patterns", "Prototipação", "Apresentação", "Aulas"],
                                    notesTitles: ["Conceito básico", "Avançado", "Top"])),
         WorkspaceViewController(workspace: Database.Mockdata.getWorkspace(withName: "Test"))]

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = workspaces.firstIndex(where: { $0 === viewController }),
            currentIndex - 1 > -1 {
            return workspaces[currentIndex - 1]
        }
        return nil
    }

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = workspaces.firstIndex(where: { $0 === viewController }),
        currentIndex + 1 < workspaces.count {
            return workspaces[currentIndex + 1]
        }
        return nil
    }

    internal func indexFor(_ viewController: UIViewController?) -> Int? {
        return workspaces.firstIndex(where: { $0 === viewController })
    }
}
