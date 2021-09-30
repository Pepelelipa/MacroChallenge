//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingViewController: ViewController {

    // MARK: - Variables and Constants
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = titleString
        lbl.font = UIFont.defaultHeader.toFirstHeaderFont()
        lbl.textColor = UIColor.titleColor
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = subtitle
        lbl.numberOfLines = 0
        lbl.font = UIFont.defaultFont.toParagraphFont()
        lbl.textColor = UIColor.bodyColor
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = false
        
        guard let imgName = imageName else {
            return UIImageView()
        }
        
        img.image = UIImage(named: imgName)
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private var titleString: String?
    private var subtitle: String?
    private var imageName: String?
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var landscapeiPhoneConstraints: [NSLayoutConstraint] = []
    private var portraitiPhoneConstraints: [NSLayoutConstraint] = []
    private var landscapeiPadConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Initializers
    
    internal init(title: String, subtitle: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleString = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
    
    required convenience init?(coder: NSCoder) {
        guard let title = coder.decodeObject(forKey: "title") as? String,
              let subtitle = coder.decodeObject(forKey: "subtitle") as? String,
              let imageName = coder.decodeObject(forKey: "imageName") as? String else {
                    return nil
            }
        self.init(title: title, subtitle: subtitle, imageName: imageName)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageView)
        
        view.backgroundColor = UIColor.formatColor
        
        setConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        if UIDevice.current.userInterfaceIdiom != .pad && UIDevice.current.userInterfaceIdiom != .mac {
            updateConstraintsForiPhone()
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            updateConstraintsForiPhone()
        } else {
            updateConstraintsForiPad()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            updateConstraintsForiPad()
        }
    }
    
    // MARK: - Functions
    
    /**
     This private method sets the constraints for different size classes and devices.
     */
    private func setConstraints() {
        
        landscapeiPhoneConstraints.append(contentsOf: [
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
                
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
        
        landscapeiPadConstraints.append(contentsOf: [
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        portraitiPhoneConstraints.append(contentsOf: [
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
        
        sharedConstraints.append(contentsOf: [
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    /**
     This method updates the view's constraints for an iPhone based on a trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func updateConstraintsForiPhone() {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if isLandscape {
            deactivate.append(contentsOf: portraitiPhoneConstraints[0].isActive ? portraitiPhoneConstraints : [])
            activate.append(contentsOf: landscapeiPhoneConstraints)
        } else {
            deactivate.append(contentsOf: landscapeiPhoneConstraints[0].isActive ? landscapeiPhoneConstraints : [])
            activate.append(contentsOf: portraitiPhoneConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
    
    /**
     This method updates the view's constraints for an iPhone based on a trait collection.
     - Parameter traitCollection: The UITraitCollection that will be used as reference to layout the constraints.
     */
    private func updateConstraintsForiPad() {
        var activate = [NSLayoutConstraint]()
        var deactivate = [NSLayoutConstraint]()
        
        let isLandscape = UIDevice.current.orientation.isActuallyLandscape
        
        if isLandscape {
            deactivate.append(contentsOf: portraitiPhoneConstraints[0].isActive ? portraitiPhoneConstraints : [])
            deactivate.append(contentsOf: landscapeiPhoneConstraints[0].isActive ? landscapeiPadConstraints : [])
            activate.append(contentsOf: landscapeiPadConstraints)
        } else {
            deactivate.append(contentsOf: landscapeiPhoneConstraints[0].isActive ? landscapeiPhoneConstraints : [])
            deactivate.append(contentsOf: landscapeiPadConstraints[0].isActive ? landscapeiPadConstraints : [])
            activate.append(contentsOf: portraitiPhoneConstraints)
        }
        
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
}
