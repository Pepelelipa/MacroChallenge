//
//  WorkspacePageControllerDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class WorkspacePageControllerDelegate: NSObject, UIPageViewControllerDelegate {

    private var willChangeTo: ((UIViewController?) -> Void)?

    /// - Parameter willChangeTo: function executed when PageViewController will change to a new view controller
    internal init(_ willChangeTo: @escaping (UIViewController?) -> Void) {
        self.willChangeTo = willChangeTo
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
         willChangeTo?(pendingViewControllers.first)
    }
}
