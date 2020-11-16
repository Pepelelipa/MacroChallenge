//
//  OnboardingPageViewControllerDelegate.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewControllerDelegate: NSObject, UIPageViewControllerDelegate {
    
    // MARK: - Variables and Constants
    
    private var pages: [UIViewController]?
    private var currentPage: ((Int) -> Void)?
    
    // MARK: - Initializers
    
    internal init(pages: [UIViewController], _ currentPage: @escaping (Int) -> Void) {
        self.pages = pages
        self.currentPage = currentPage
    }
    
    // MARK: - UIPageViewControllerDelegate Functions
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let pages = pages, let viewControllerIndex = pages.firstIndex(of: viewControllers[0]) {
                currentPage?(viewControllerIndex)
            }
        }
    }
}
