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
    
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()

    internal var isLandscape: Bool = false {
        didSet {
            imageView.isHidden = isLandscape
            
            if isLandscape {
                NSLayoutConstraint.deactivate(portraitConstraints)
                NSLayoutConstraint.activate(landscapeConstraints)
            } else {
                NSLayoutConstraint.deactivate(landscapeConstraints)
                NSLayoutConstraint.activate(portraitConstraints)
            }
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(button)
        stack.spacing = 1
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = descriptionText
        label.font = UIFont.defaultHeader.toStyle(.h3)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        label.adjustsFontSizeToFitWidth = true
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
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .vertical)
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = RoundCornerButton(textColor: UIColor(named: "Action"), fillColor: .clear, borderColor: UIColor(named: "Action"), cornerRadius: 10)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3)
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
        self.addSubview(stackView)
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
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        portraitConstraints = [
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ]
        
        landscapeConstraints = [
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            
            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
        ]
        
        if isLandscape {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }
    
    // MARK: - Objective-C functions
    
    @objc private func handleAction() {
        action()
    }
}
