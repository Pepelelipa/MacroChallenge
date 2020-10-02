//
//  AddWorkspaceViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddWorkspaceViewController: UIViewController {

    private var dismissHandler: (() -> Void)?
    internal init(dismissHandler: (() -> Void)? = nil) {
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
    }
    required convenience init?(coder: NSCoder) {
        self.init()
    }

    var backgroundBlur: UIView?
    internal func moveTo(_ viewController: UIViewController) {
        willMove(toParent: viewController)
        let backgroundBlur = UIView()
        self.backgroundBlur = backgroundBlur
        backgroundBlur.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlur.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        viewController.view.addSubview(backgroundBlur)
        NSLayoutConstraint.activate([
            backgroundBlur.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            backgroundBlur.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            backgroundBlur.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
            backgroundBlur.heightAnchor.constraint(equalTo: viewController.view.heightAnchor)
        ])

        viewController.addChild(self)
        viewController.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            view.heightAnchor.constraint(greaterThanOrEqualTo: viewController.view.heightAnchor, multiplier: 0.18)
        ])

        didMove(toParent: viewController)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundBlur.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func backgroundTap() {
        dismissFromParent()
    }

    func dismissFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        didMove(toParent: nil)
        view.removeFromSuperview()
        backgroundBlur?.removeFromSuperview()
        dismissHandler?()
    }
}
