//
//  PopupContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class PopupContainerViewController: UIViewController {
    private var dismissHandler: (() -> Void)?
    internal init(dismissHandler: (() -> Void)? = nil) {
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
    }
    required convenience init?(coder: NSCoder) {
        self.init(dismissHandler: coder.decodeObject(forKey: "dismissHandler") as? () -> Void)
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

        didMove(toParent: viewController)

        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundBlur.addGestureRecognizer(backgroundTapGestureRecognizer)

        let selfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfTap))
        view.addGestureRecognizer(selfTapGestureRecognizer)
    }
    @IBAction internal func selfTap() {
        resignFirstResponder()
    }
    @IBAction internal func backgroundTap() {
        dismissFromParent()
    }
    internal func dismissFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        didMove(toParent: nil)
        view.removeFromSuperview()
        backgroundBlur?.removeFromSuperview()
        dismissHandler?()
    }
}
