//
//  OnboardingPageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    // MARK: - Variables and Constants
    
    private var pages: [UIViewController]?
    
    // MARK: - Initializers
    
    internal init(pages: [UIViewController]) {
        self.pages = pages
    }
    
    // MARK: - UIPageViewControllerDataSource Functions
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let pages = self.pages,
           let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return pages.last
            } else {
                return pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let pages = self.pages, let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                return pages[viewControllerIndex + 1]
            } else {
                return pages.first
            }
        }
        return nil
        
    }
}
