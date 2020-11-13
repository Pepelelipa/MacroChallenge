//
//  OnboardingPageViewControllerDataSource.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
//        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
//            if viewControllerIndex == 0 {
//                return self.pages.last
//            } else {
//                return self.pages[viewControllerIndex - 1]
//            }
//        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
//            if viewControllerIndex < self.pages.count - 1 {
//                return self.pages[viewControllerIndex + 1]
//            } else {
//                return self.pages.first
//            }
//        }
        return nil
        
    }
}
