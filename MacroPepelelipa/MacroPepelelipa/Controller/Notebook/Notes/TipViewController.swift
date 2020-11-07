//
//  TipViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import MarkdownText

internal class TipViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let tipTitle: UILabel = {
        let label = UILabel()

        label.text = "Tips".localized()
        label.font = UIFont.defaultHeader.toStyle(.h1)
        label.tintColor = UIColor.titleColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var markupTitle: UILabel = {
        let label = UILabel()

        label.text = "Markdown".localized()
        label.font = UIFont.defaultHeader.toStyle(.h2)
        label.tintColor = UIColor.titleColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var inputViewTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Settings Bar".localized()
        label.font = UIFont.defaultHeader.toStyle(.h2)
        label.tintColor = UIColor.titleColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        return label
    }() 
    
    private lazy var supportMarkdownView = UIView()

    private lazy var markdownArtifact: UILabel = {
        let label = UILabel()
        
        let text = NSMutableAttributedString()

        let attributedStringsParts: [NSAttributedString] = [
            "Bold".localized().toStyle(.bold),
            "Italic".localized().toStyle(.italic)
        ]
        
        let mutableattributedStringsParts: [NSMutableAttributedString] = [
            NSMutableAttributedString(attributedString: "Highlighted".localized().toStyle(.paragraph)),
            NSMutableAttributedString(attributedString: "Underline".localized().toStyle(.paragraph))
        ]
        
        mutableattributedStringsParts[0].addAttribute(NSAttributedString.Key.backgroundColor, 
                                                      value: UIColor.highlightColor ?? .systemYellow, 
                                                      range: NSRange(location: 0, length: mutableattributedStringsParts[0].length))
        
        mutableattributedStringsParts[1].addAttribute(NSAttributedString.Key.underlineStyle, 
                                                      value: NSNumber.init(value: NSUnderlineStyle.single.rawValue), 
                                                      range: NSRange(location: 0, length: mutableattributedStringsParts[1].length))
        
        for part in attributedStringsParts {
            text.append(part)
            text.append(NSAttributedString(string: "\n"))
            text.append(NSAttributedString(string: "\n"))

        }
        
        for part in mutableattributedStringsParts {
            text.append(part)
            text.append(NSAttributedString(string: "\n"))
            text.append(NSAttributedString(string: "\n"))
        }
        
        label.attributedText = text
        label.font = UIFont.defaultHeader.toStyle(.paragraph)
        label.tintColor = UIColor.bodyColor
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        return label
    }()
    
    private lazy var markdownArtifactSizeHeight: CGFloat = markdownArtifact.intrinsicContentSize.height
    
    private lazy var markdownArtifactExplanation: UILabel = {
        let label = UILabel()
        
        let text = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right

        let attributedStringsParts: [NSAttributedString] = [
            "Bold explanation".localized().toStyle(.paragraph),
            "Italic explanation".localized().toStyle(.paragraph),
            "Highlighted explanation".localized().toStyle(.paragraph),
            "Underline explanation".localized().toStyle(.paragraph)
        ]
        
        for part in attributedStringsParts {
            text.append(part)
            text.append(NSAttributedString(string: "\n"))
            text.append(NSAttributedString(string: "\n"))
        }
        
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
        
        label.attributedText = text
        label.font = UIFont.defaultHeader.toStyle(.paragraph)
        label.tintColor = UIColor.bodyColor
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        return label
    }()
    
    private lazy var inputViewExplanation: UILabel = {
        
        let label = UILabel()
        
        label.text = "InputView explanation".localized()
        label.font = UIFont.defaultHeader.toStyle(.paragraph)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var inputViewExplanationHeight: CGFloat = inputViewExplanation.intrinsicContentSize.height
    
    private lazy var inputViewImageView: UIImageView = {
        let image = UIImage(named: "InputViewAsset")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var inputViewStack: UIStackView = {
        let stack = UIStackView()
        
        let highlightTip = InputViewTipsStack(of: .highlighted)
        let boldTip = InputViewTipsStack(of: .bold)
        let italicTip = InputViewTipsStack(of: .italic)
        
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 2
        
        stack.addArrangedSubview(highlightTip)
        stack.addArrangedSubview(boldTip)
        stack.addArrangedSubview(italicTip)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(stack)
        return stack
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            tipTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tipTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tipTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tipTitle.heightAnchor.constraint(equalToConstant: 30),

            scrollView.topAnchor.constraint(equalTo: self.tipTitle.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            markupTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            markupTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            markupTitle.heightAnchor.constraint(equalToConstant: 32),
            markupTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            supportMarkdownView.topAnchor.constraint(equalTo: markupTitle.bottomAnchor, constant: 34),
            supportMarkdownView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            supportMarkdownView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            supportMarkdownView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3),
            
            markdownArtifact.topAnchor.constraint(equalTo: supportMarkdownView.topAnchor),
            markdownArtifact.leadingAnchor.constraint(equalTo: supportMarkdownView.leadingAnchor, constant: 20),
            markdownArtifact.heightAnchor.constraint(equalTo: supportMarkdownView.heightAnchor),
            markdownArtifact.widthAnchor.constraint(equalTo: supportMarkdownView.widthAnchor, multiplier: 0.5),
            
            markdownArtifactExplanation.topAnchor.constraint(equalTo: supportMarkdownView.topAnchor),
            markdownArtifactExplanation.trailingAnchor.constraint(equalTo: supportMarkdownView.trailingAnchor, constant: -20),
            markdownArtifactExplanation.heightAnchor.constraint(equalTo: supportMarkdownView.heightAnchor),
            markdownArtifactExplanation.widthAnchor.constraint(equalTo: supportMarkdownView.widthAnchor, multiplier: 0.44),
            
            inputViewTitle.topAnchor.constraint(equalTo: supportMarkdownView.bottomAnchor, constant: 20),
            inputViewTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            inputViewTitle.heightAnchor.constraint(equalToConstant: 34),
            inputViewTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputViewExplanation.topAnchor.constraint(equalTo: inputViewTitle.bottomAnchor, constant: 34),
            inputViewExplanation.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            inputViewExplanation.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            inputViewExplanation.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.14),
            
            inputViewImageView.topAnchor.constraint(equalTo: inputViewExplanation.bottomAnchor, constant: 34),
            inputViewImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            inputViewImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            inputViewImageView.heightAnchor.constraint(equalTo: inputViewImageView.widthAnchor, multiplier: 0.6),
            
            inputViewStack.topAnchor.constraint(equalTo: inputViewImageView.bottomAnchor, constant: 34),
            inputViewStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            inputViewStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            inputViewStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.344),
            inputViewStack.heightAnchor.constraint(equalTo: inputViewStack.widthAnchor, multiplier: 0.6)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.addSubview(supportMarkdownView)
        self.supportMarkdownView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tipTitle)
        
        self.view.backgroundColor = .backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraints)
    }
    
}
