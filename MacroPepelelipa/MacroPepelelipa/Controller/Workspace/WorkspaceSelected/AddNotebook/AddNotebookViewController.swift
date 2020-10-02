//
//  AddNotebookViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class AddNotebookViewController: PopupContainerViewController {
    override func moveTo(_ viewController: UIViewController) {
        super.moveTo(viewController)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.7),
            view.widthAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.78)
        ])
    }
}
