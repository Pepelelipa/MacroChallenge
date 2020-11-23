//
//  OnboardingPageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class OnboardingPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    // MARK: - Variables and Constants
    
    private var pages: [UIViewController]
    
    // MARK: - Initializers
    
    internal init(pages: [UIViewController]) {
        self.pages = pages
    }

    internal func indexFor(_ viewController: UIViewController) -> Int? {
        return pages.firstIndex(of: viewController)
    }

    internal func viewControllerFor(_ index: Int) -> UIViewController? {
        if index > -1 && index < pages.count {
            return pages[index]
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDataSource Functions
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return nil
            } else {
                return pages[viewControllerIndex - 1]
            }
        }
        return nil
    }

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                return pages[viewControllerIndex + 1]
            } else {
                return nil
            }
        }
        return nil
        
    }
}
