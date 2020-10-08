//
//  MarkupContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MarkupContainerViewController: UIViewController {
    
    private weak var viewController: NotesViewController?
    private weak var textView: MarkupTextView?
    public weak var delegate: MarkupFormatViewDelegate?
    
    private lazy var colorSelector: [MarkupToggleButton] = {
        var buttons = [MarkupToggleButton]()
        var buttonColors: [UIColor] = [
            UIColor.bodyColor ?? .black,
            UIColor.notebookColors[14],
            UIColor.notebookColors[12]
        ]
        
        buttonColors.forEach { (color) in
            var newButton = MarkupToggleButton(frame: .zero, color: color)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(newButton)
        }
        
        return buttons
    }()
    
    private lazy var formatSelector: [MarkupToggleButton] = {
        var buttons = [MarkupToggleButton]()
        var imageNames = ["italic", "bold", "pencil.tip"]
        
        imageNames.forEach { (imageName) in
            var newButton = createButton(
                normalStateImage: UIImage(systemName: imageName),
                titleLabel: nil
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(newButton)
        }
        
        buttons[0].addTarget(delegate, action: #selector(delegate?.makeTextItalic), for: .touchDown)
        buttons[1].addTarget(delegate, action: #selector(delegate?.makeTextBold), for: .touchDown)
        buttons[2].addTarget(delegate, action: #selector(delegate?.highlightText), for: .touchUpInside)
        
        return buttons
    }()
    
    private lazy var fontSelector: [MarkupToggleButton] = {
        var buttons = [MarkupToggleButton]()
        var fontName = ["Merriweather", "Open Sans", "Dancin"]
        
        fontName.forEach { (fontName) in
            var newButton = createButton(
                normalStateImage: nil,
                titleLabel: fontName
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(delegate, action: #selector(delegate?.placeHolderAction), for: .touchDown)
            buttons.append(newButton)
        }
        
        return buttons
    }()
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.backgroundColor
        
        
        colorSelector.forEach { (selector) in
            view.addSubview(selector)
        }
        
        formatSelector.forEach { (selector) in
            view.addSubview(selector)
        }
        
        fontSelector.forEach { (selector) in
            view.addSubview(selector)
        }
        
        createConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        colorSelector.forEach { (selector) in
            selector.setCornerRadius()
        }
        
        updateSelectors()
    }

    /**
     This method creates a MarkupToggleButton with a UIImage or a title.
     
     - Parameters:
        - normalStateImage: The UIImage that will be the button's background.
        - titleLabel: The string containing the button's title.
     
     - Returns: The created MarkupToggleButton.
     */
    private func createButton(normalStateImage: UIImage?, titleLabel: String?) -> MarkupToggleButton {
        var button = MarkupToggleButton(normalStateImage: nil, title: nil)
        
        if normalStateImage != nil {
            let markupButton = MarkupToggleButton(normalStateImage: normalStateImage, title: nil)
            button = markupButton
        } else if titleLabel != nil {
            let markupButton = MarkupToggleButton(normalStateImage: nil, title: titleLabel)
            button = markupButton
        }
        return button
    }
    
    /**
     This method sets the constraints for the inner elements of the container view.
     */
    public func createConstraints() {
        
        setFontSelectorConstraints()
        setColorSelectorConstraints()
        setFormatSelectorConstraints()
    }
    
    /**
     This method sets the contraints for the font selector buttons.
     */
    private func setFontSelectorConstraints() {
        NSLayoutConstraint.activate([
            fontSelector[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fontSelector[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fontSelector[1].leadingAnchor.constraint(equalTo: fontSelector[0].trailingAnchor, constant: 6)
        ])
        
        fontSelector.forEach { (selector) in
            NSLayoutConstraint.activate([
                selector.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                selector.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
            ])
        }
    }
    
    /**
     This method sets the contraints for the color selector buttons.
     */
    private func setColorSelectorConstraints() {
        
        NSLayoutConstraint.activate([
            colorSelector[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            colorSelector[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorSelector[0].bottomAnchor.constraint(greaterThanOrEqualTo: fontSelector[0].bottomAnchor, constant: -16),
            colorSelector[0].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            colorSelector[0].widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
        
        for index in 1..<colorSelector.count {
            NSLayoutConstraint.activate([
                colorSelector[index].topAnchor.constraint(equalTo: colorSelector[0].topAnchor),
                colorSelector[index].leadingAnchor.constraint(equalTo: colorSelector[index - 1].trailingAnchor, constant: 10),
                colorSelector[index].bottomAnchor.constraint(equalTo: colorSelector[0].bottomAnchor),
                colorSelector[index].heightAnchor.constraint(equalTo: colorSelector[0].heightAnchor),
                colorSelector[index].widthAnchor.constraint(equalTo: colorSelector[0].widthAnchor)
            ])
        }
    }
    
    /**
     This method sets the contraints for the format selector buttons.
     */
    private func setFormatSelectorConstraints() {
        NSLayoutConstraint.activate([
            formatSelector[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            formatSelector[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formatSelector[0].bottomAnchor.constraint(greaterThanOrEqualTo: fontSelector[2].bottomAnchor, constant: -16),
            formatSelector[0].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            formatSelector[0].widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
        ])
        
        for index in 1..<formatSelector.count {
            NSLayoutConstraint.activate([
                formatSelector[index].topAnchor.constraint(equalTo: formatSelector[0].topAnchor),
                formatSelector[index].trailingAnchor.constraint(equalTo: formatSelector[index - 1].leadingAnchor, constant: -16),
                formatSelector[index].bottomAnchor.constraint(equalTo: formatSelector[0].bottomAnchor),
                formatSelector[index].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
                formatSelector[index].widthAnchor.constraint(equalTo: formatSelector[0].widthAnchor)
            ])
        }
    }
    
    /**
     This public methos updates the selectors appearence based on the text style.
     */
    public func updateSelectors() {
        formatSelector[0].isSelected = textView?.checkTrait(.traitItalic) ?? false
        formatSelector[1].isSelected = textView?.checkTrait(.traitBold) ?? false
        formatSelector[2].isSelected = textView?.checkBackground() ?? false

        formatSelector.forEach { (button) in
            button.setTintColor()
        }
    }
}
