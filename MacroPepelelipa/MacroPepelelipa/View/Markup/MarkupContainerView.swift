//
//  MarkupContainerView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupContainerView: UIView {
    
    private weak var textView: MarkupTextView?
    
    private lazy var backgroundView: UIView = {
        let bckView = UIView(frame: .zero)
        bckView.backgroundColor = UIColor(named: "Background")
        bckView.layer.cornerRadius = 15
        bckView.translatesAutoresizingMaskIntoConstraints = false
        return bckView
    }()
    
    private lazy var cancelContainer: MarkupToogleButton = {
        let button = createButton(
            action: #selector(dismissContainer),
            normalStateImage: UIImage(systemName: "xmark.circle"),
            titleLabel: nil
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var formatLabel: UILabel = {
        let fmtLabel = UILabel(frame: .zero)
        fmtLabel.text = "Format".localized()
        fmtLabel.font = fmtLabel.font.withSize(22)
        #warning("Change the way the color is called")
        fmtLabel.textColor = UIColor(named: "Body")
        
        fmtLabel.translatesAutoresizingMaskIntoConstraints = false
        return fmtLabel
    }()
    
    private lazy var firstColorSelector: MarkupToogleButton = {
        let button = MarkupToogleButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22), color: .red)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondColorSelector: MarkupToogleButton = {
        let button = MarkupToogleButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22), color: .green)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    private lazy var thirdColorSelector: MarkupToogleButton = {
        let button = MarkupToogleButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22), color: .blue)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
       
    private lazy var italicText: MarkupToogleButton = {
        let button = createButton(
            action: #selector(placeHolderAction),
            normalStateImage: UIImage(systemName: "italic"),
            titleLabel: nil
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var boldText: MarkupToogleButton = {
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: UIImage(systemName: "bold"), titleLabel: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var highlightText: MarkupToogleButton = {
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: UIImage(systemName: "pencil.tip"), titleLabel: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var firstFontSelector: MarkupToogleButton = {
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: nil, titleLabel: "Merriweather")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
           
    private lazy var secondFontSelector: MarkupToogleButton = {
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: nil, titleLabel: "Open Sans")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var thirdFontSelector: MarkupToogleButton = {
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: nil, titleLabel: "Dancin")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, owner: MarkupTextView) {
        self.textView = owner
        
        super.init(frame: frame)
        
        self.backgroundColor = .gray//UIColor(named: "Background")
        
        let buttons = [firstColorSelector, secondColorSelector, thirdColorSelector, italicText, boldText, highlightText, firstFontSelector, secondFontSelector, thirdFontSelector, cancelContainer, formatLabel]
        
        self.addSubview(backgroundView)
        buttons.forEach {
            backgroundView.addSubview($0)
        }
        
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(action: Selector, normalStateImage: UIImage?, titleLabel: String?) -> MarkupToogleButton {
        var button = MarkupToogleButton(normalStateImage: nil, title: nil)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        if normalStateImage != nil {
            let markupButton = MarkupToogleButton(normalStateImage: normalStateImage, title: nil)
            button = markupButton
        } else if titleLabel != nil {
            let markupButton = MarkupToogleButton(normalStateImage: nil, title: titleLabel)
            button = markupButton
        }
        return button
    }
    
    public func createConstraints() {
        
        backgroundView.layer.zPosition = -1
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            cancelContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            cancelContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            cancelContainer.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.18),
            cancelContainer.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.18)
        ])
        
        NSLayoutConstraint.activate([
            formatLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            formatLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            formatLabel.trailingAnchor.constraint(equalTo: cancelContainer.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            firstFontSelector.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            firstFontSelector.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            firstFontSelector.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.28),
            firstFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            thirdFontSelector.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            thirdFontSelector.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            thirdFontSelector.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.28),
            thirdFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            secondFontSelector.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            secondFontSelector.leadingAnchor.constraint(equalTo: firstFontSelector.trailingAnchor, constant: 10),
            secondFontSelector.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.28),
            secondFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            firstColorSelector.bottomAnchor.constraint(equalTo: firstFontSelector.topAnchor, constant: -20),
            firstColorSelector.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            secondColorSelector.bottomAnchor.constraint(equalTo: firstFontSelector.topAnchor, constant: -20),
            secondColorSelector.leadingAnchor.constraint(equalTo: firstColorSelector.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            thirdColorSelector.bottomAnchor.constraint(equalTo: firstFontSelector.topAnchor, constant: -20),
            thirdColorSelector.leadingAnchor.constraint(equalTo: secondColorSelector.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            italicText.bottomAnchor.constraint(equalTo: thirdFontSelector.topAnchor, constant: -20),
            italicText.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            italicText.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            italicText.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.18)
        ])
        
        NSLayoutConstraint.activate([
            boldText.bottomAnchor.constraint(equalTo: thirdFontSelector.topAnchor, constant: -20),
            boldText.trailingAnchor.constraint(equalTo: italicText.leadingAnchor, constant: -16),
            boldText.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            boldText.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.18)
        ])
        
        NSLayoutConstraint.activate([
            highlightText.bottomAnchor.constraint(equalTo: thirdFontSelector.topAnchor, constant: -20),
            highlightText.trailingAnchor.constraint(equalTo: boldText.leadingAnchor, constant: -16),
            highlightText.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            highlightText.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.18)
        ])
    }
    
    @objc func dismissContainer() {
        
    }
    
    @objc func placeHolderAction() {
        
    }
}
