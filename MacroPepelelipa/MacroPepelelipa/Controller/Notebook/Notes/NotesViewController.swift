//
//  NotesViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class NotesViewController: UIViewController {

    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false

        return btn
    }()

    public var isBtnBackHidden: Bool {
        get {
            return btnBack.isHidden
        }
        set {
            btnBack.isHidden = newValue
        }
    }

    public override func viewDidLoad() {
        view.addSubview(btnBack)
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .phone {
            btnBack.isHidden = UIDevice.current.orientation.isLandscape
        } else if dev == .pad {
            btnBack.isHidden = true
        }
    }

    public override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }

    ///Go back to the previous step(opens the notebook index) according to the device and orientation
    @IBAction func btnBackTap(_ sender: UIButton) {
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .pad {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        } else {
            if UIDevice.current.orientation.isLandscape {
                splitViewController?.preferredDisplayMode = .primaryOverlay
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
