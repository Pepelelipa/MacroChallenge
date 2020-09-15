//
//  CollectionViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspacePageViewController: UIPageViewController {
    private var workspaceDataSource = WorkspacePageControllerDataSource()

    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }

    required convenience init?(coder: NSCoder) {
        if let options =
            coder.decodeObject(forKey: "options") as? [UIPageViewController.OptionsKey: Any]? {
            self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        } else {
            self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }
    }

    override func viewDidLoad() {
        self.dataSource = workspaceDataSource
        if let first = workspaceDataSource.workspaces.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        view.backgroundColor = .red
    }

    var collections: [WorkspaceViewController] = [WorkspaceViewController()]
}
