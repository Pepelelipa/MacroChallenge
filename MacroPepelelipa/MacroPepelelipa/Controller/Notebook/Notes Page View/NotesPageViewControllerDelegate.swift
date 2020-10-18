//
//  NotesPageViewControllerDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotesPageViewControllerDelegate: NSObject, UIPageViewControllerDelegate {
    
    // MARK: - Variables and Constants
    
    private var updateviewControllers: ((UIViewController?) -> Void)?
    
    // MARK: - Initializers
    
    internal init(_ updateviewControllers: @escaping (UIViewController?) -> Void) {
        self.updateviewControllers = updateviewControllers
    }
    
    // MARK: - UIPageViewControllerDelegate functions
    
    internal func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        updateviewControllers?(pendingViewControllers.first)
    }
}
