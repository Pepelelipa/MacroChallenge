//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

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
    
    internal init(title: String, subtitle: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleString = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageView)
        
        view.backgroundColor = UIColor.formatColor
        
        setConstraints()
    }
    
    // MARK: - Functions
    
    /**
     This private method sets the constraints for different size classes and devices.
     */
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
    }
}
