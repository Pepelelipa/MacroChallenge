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

    @available(iOS 14, *)
    override init(style: UISplitViewController.Style) {
        super.init(style: .doubleColumn)
        preferredPrimaryColumnWidth = 1/3
        setup()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required convenience init?(coder: NSCoder) {
        if #available(iOS 14.0, *),
           let style = coder.decodeObject(forKey: "style") as? UISplitViewController.Style {
            self.init(style: style)
        } else {
            self.init()
        }
    }

    private func setup() {
        modalPresentationStyle = .fullScreen
        viewControllers = [navController, detail]
        master.delegate = self
        preferredDisplayMode = .primaryOverlay
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
