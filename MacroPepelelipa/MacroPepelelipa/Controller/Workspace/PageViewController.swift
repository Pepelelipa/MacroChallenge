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

    private lazy var workspaceDelegate = WorkspacePageControllerDelegate { (viewController) in
        if let index = self.workspaceDataSource.indexFor(viewController) {
            self.pageControl.currentPage = index
        }
    }

    private lazy var pageControl: UIPageControl = {
        let pgControl = UIPageControl(frame: .zero)

        pgControl.numberOfPages = workspaceDataSource.workspaces.count
        pgControl.currentPage = 0
        pgControl.isUserInteractionEnabled = true
        pgControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        pgControl.translatesAutoresizingMaskIntoConstraints = false

        return pgControl
    }()

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
        self.delegate = workspaceDelegate
        if let first = workspaceDataSource.workspaces.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        view.backgroundColor = .clear
        view.addSubview(pageControl)
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }

    ///Sets the view controllers on the PageViewController when to the UIPageControl page changes
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        guard let current = viewControllers?.first,
            let toBePreviousIndex = workspaceDataSource.indexFor(current) else {
            return
        }

        let nextIndex = sender.currentPage

        setViewControllers([self.workspaceDataSource.workspaces[sender.currentPage]],
                           direction: nextIndex > toBePreviousIndex ? .forward : .reverse,
                           animated: true)
    }
}
