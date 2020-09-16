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

    private var pageControl: UIPageControl = UIPageControl(frame: .zero)

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

        setupPageControl()
    }

    private func setupPageControl() {

        self.pageControl.numberOfPages = workspaceDataSource.workspaces.count
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = true
        self.pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }

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
