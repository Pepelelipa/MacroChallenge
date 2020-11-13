//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 13/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = titleString
        lbl.font = UIFont.defaultHeader.toStyle(.h3)
        lbl.textColor = UIColor.bodyColor
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = subtitle
        lbl.numberOfLines = 2
        lbl.font = UIFont.defaultHeader.toStyle(.paragraph)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }

}
