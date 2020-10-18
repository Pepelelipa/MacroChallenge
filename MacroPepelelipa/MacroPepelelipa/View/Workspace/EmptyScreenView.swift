//
//  WorkspaceEmptyView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 15/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class EmptyScreenView: UIView {
    
    // MARK: - Variables and Constants
    
    private var descriptionText: String
    private var imageName: String
    private var buttonTitle: String
    private var action: () -> Void

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = descriptionText
        label.font = MarkdownHeader.thirdHeaderFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        guard let image = UIImage(named: imageName) else {
            return UIImageView(frame: .zero)
        }
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.actionColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = UIColor.backgroundColor
        button.setBackgroundImage(UIImage(named: "btnWorkspaceBackground"), for: .normal)
        button.layer.cornerRadius = 22
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = MarkdownHeader.thirdHeaderFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        self.descriptionText = ""
        self.imageName = ""
        self.buttonTitle = ""
        self.action = {}
        super.init(frame: frame)
    }
    
    internal init(frame: CGRect, descriptionText: String, imageName: String, buttonTitle: String, action: @escaping () -> Void) {
        self.descriptionText = descriptionText
        self.imageName = imageName
        self.action = action
        self.buttonTitle = buttonTitle
        
        super.init(frame: frame)
        self.addSubview(descriptionLabel)
        self.addSubview(imageView)
        self.addSubview(button)
        setConstraints()
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Functions
    
    ///This private method sets the constraints for the subviews in this view.
    private func setConstraints() {
        descriptionLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Objective-C functions
    
    @objc private func handleAction() {
        action()
    }
}
