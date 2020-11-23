//
//  OnboardingPageViewControllerDelegate.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewControllerDelegate: NSObject, UIPageViewControllerDelegate {

    private let didFinishAnimation: (() -> Void)?

    // MARK: - Initializers
    internal init(didFinishAnimation: @escaping () -> Void) {
        self.didFinishAnimation = didFinishAnimation
        super.init()
    }

    // MARK: - UIPageViewControllerDelegate Functions
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        didFinishAnimation?()
    }
}
