//
//  DemoLaunchViewController.swift
//  MacroPepelelipa
//
//  Created by Karina Paula on 16/09/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class DemoLaunchViewController: UIViewController {
    @IBOutlet weak var launchAppIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchAppIcon.layer.cornerRadius = 24
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.insertSubview(blurEffectView, at: 1)
        #if DEBUG || DEVELOP
        let time = 0.5
        #else
        let time = 4.0
        #endif
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
