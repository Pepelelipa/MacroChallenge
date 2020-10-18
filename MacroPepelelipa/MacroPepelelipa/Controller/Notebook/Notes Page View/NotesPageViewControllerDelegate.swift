//
//  NotesPageViewControllerDelegate.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class NotesPageViewControllerDelegate: NSObject, UIPageViewControllerDelegate {
    
    private var updateviewControllers: ((UIViewController?) -> Void)?

    init(_ updateviewControllers: @escaping (UIViewController?) -> Void) {
        self.updateviewControllers = updateviewControllers
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        updateviewControllers?(pendingViewControllers.first)
    }
}
