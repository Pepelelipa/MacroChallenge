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
        let button = createButton(action: #selector(placeHolderAction), normalStateImage: nil, titleLabel: "Merrieather")
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
        
        let buttons = [firstColorSelector, secondColorSelector, thirdColorSelector, italicText, boldText, highlightText, firstFontSelector, secondFontSelector, thirdFontSelector]
        buttons.forEach {
            self.addSubview($0)
        }
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(action: Selector, normalStateImage: UIImage?, titleLabel: String?) -> MarkupToogleButton {
        var button = MarkupToogleButton(frame: .zero, normalStateImage: nil, title: nil)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        if normalStateImage != nil {
            let markupButton = MarkupToogleButton(frame: .zero, normalStateImage: normalStateImage, title: nil)
            button = markupButton
        } else if titleLabel != nil {
            let markupButton = MarkupToogleButton(frame: .zero, normalStateImage: nil, title: titleLabel)
            button = markupButton
        }
        return button
    }
    
    public func createConstraints() {
        NSLayoutConstraint.activate([
            firstColorSelector.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            firstColorSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            firstColorSelector.widthAnchor.constraint(equalToConstant: 22),
            firstColorSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            secondColorSelector.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            secondColorSelector.leadingAnchor.constraint(equalTo: firstColorSelector.trailingAnchor, constant: 16),
            secondColorSelector.widthAnchor.constraint(equalToConstant: 22),
            secondColorSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            thirdColorSelector.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            thirdColorSelector.leadingAnchor.constraint(equalTo: secondColorSelector.trailingAnchor, constant: 16),
            thirdColorSelector.widthAnchor.constraint(equalToConstant: 22),
            thirdColorSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            italicText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            italicText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            italicText.widthAnchor.constraint(equalToConstant: 18),
            italicText.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            boldText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            boldText.trailingAnchor.constraint(equalTo: italicText.leadingAnchor, constant: -16),
            boldText.widthAnchor.constraint(equalToConstant: 18),
            boldText.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            highlightText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            highlightText.trailingAnchor.constraint(equalTo: boldText.leadingAnchor, constant: -16),
            highlightText.widthAnchor.constraint(equalToConstant: 18),
            highlightText.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            firstFontSelector.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            firstFontSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            firstFontSelector.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28),
            firstFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            thirdFontSelector.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            thirdFontSelector.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            thirdFontSelector.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28),
            thirdFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            secondFontSelector.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            secondFontSelector.leadingAnchor.constraint(equalTo: firstFontSelector.trailingAnchor, constant: 10),
            secondFontSelector.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28),
            secondFontSelector.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    @objc func placeHolderAction() {
        
    }
}
