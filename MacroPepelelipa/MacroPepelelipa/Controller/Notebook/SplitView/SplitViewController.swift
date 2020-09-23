//
//  SplitViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class SplitViewController: UISplitViewController, NotebookIndexDelegate {

    private let master = NotebookIndexViewController()
    private lazy var navController: UINavigationController = {
        let nav = UINavigationController(rootViewController: master)
        nav.isNavigationBarHidden = true

        return nav
    }()
    private let detail = NotesViewController()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        viewControllers = [navController, detail]
        master.delegate = self
        preferredDisplayMode = .primaryOverlay
    }

    required convenience init?(coder: NSCoder) {
        self.init()
    }

    func indexShouldDismiss() {
        self.dismiss(animated: true)
    }

    func indexWillAppear() {
        detail.isBtnBackHidden = true
    }

    func indexWillDisappear() {
        detail.isBtnBackHidden = false
    }

    ///Animates the dismissal with our custom animation
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.fade
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window?.layer.add(transition, forKey: kCATransition)
        }
        super.dismiss(animated: false, completion: completion)
    }
}
