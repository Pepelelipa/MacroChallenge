//
//  WorkspacePageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspacePageControllerDataSource: NSObject, UIPageViewControllerDataSource {
    #warning("No actual data being fed to the source.")
    internal private(set) var workspaces: [WorkspaceViewController] =
        [WorkspaceViewController(), WorkspaceViewController()]

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = workspaces.firstIndex(where: { $0 === viewController }),
            currentIndex - 1 > -1 {
            return workspaces[currentIndex - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = workspaces.firstIndex(where: { $0 === viewController }),
        currentIndex + 1 < workspaces.count {
            return workspaces[currentIndex + 1]
        }
        return nil
    }

    func indexFor(_ viewController: UIViewController?) -> Int? {
        return workspaces.firstIndex(where: { $0 === viewController })
    }
}
