//
//  MarkupContainerView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupContainerView: UIView, TextEditingDelegateObserver {
    
    private weak var textView: MarkupTextView?
    private weak var viewController: NotesViewController?
    public weak var delegate: MarkupFormatViewDelegate?
        
    private lazy var backgroundView: UIView = {
        let bckView = UIView(frame: .zero)
        bckView.backgroundColor = .white
        bckView.layer.cornerRadius = 15
        bckView.translatesAutoresizingMaskIntoConstraints = false
        
        return bckView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.placeholderColor
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(delegate, action: #selector(delegate?.dismissContainer), for: .touchDown)

        return button
    }()
    
    private lazy var formatLabel: UILabel = {
        let fmtLabel = UILabel(frame: .zero)
        fmtLabel.text = "Format".localized()
        fmtLabel.font = fmtLabel.font.withSize(22)
        fmtLabel.textColor = UIColor.bodyColor
        
        fmtLabel.translatesAutoresizingMaskIntoConstraints = false
        return fmtLabel
    }()
    
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
        buttons[2].addTarget(delegate, action: #selector(delegate?.highlightText), for: .touchDown)
        
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
    
    init(frame: CGRect, owner: MarkupTextView, delegate: MarkupFormatViewDelegate?, viewController: NotesViewController) {
        self.textView = owner
        self.delegate = delegate
        self.viewController = viewController
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.backgroundColor
                
        self.addSubview(backgroundView)
        
        colorSelector.forEach { (selector) in
            backgroundView.addSubview(selector)
        }
        
        formatSelector.forEach { (selector) in
            backgroundView.addSubview(selector)
        }
        
        fontSelector.forEach { (selector) in
            backgroundView.addSubview(selector)
        }
        
        backgroundView.addSubview(dismissButton)
        backgroundView.addSubview(formatLabel)
        
        createConstraints()
        
        (viewController.textView.delegate as? MarkupTextViewDelegate)?.addObserver(self)
    }
    
    deinit {
        (self.textView?.delegate as? MarkupTextViewDelegate)?.removeObserver(self)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
        let owner = coder.decodeObject(forKey: "owner") as? MarkupTextView,
        let viewController = coder.decodeObject(forKey: "viewController") as? NotesViewController else {
            return nil
        }
        let delegate = coder.decodeObject(forKey: "delegate") as? MarkupFormatViewDelegate
        self.init(frame: frame, owner: owner, delegate: delegate, viewController: viewController)
    }
    
    func textReceivedEnter() {
        formatSelector.forEach({
            $0.toogleButton()
        })
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
        backgroundView.layer.zPosition = -1
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            formatLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            formatLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            formatLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            dismissButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15)
        ])
        
        setFontSelectorConstraints()
        setColorSelectorConstraints()
        setFormatSelectorConstraints()
    }
    
    /**
     This method sets the contraints for the font selector buttons.
     */
    private func setFontSelectorConstraints() {
        NSLayoutConstraint.activate([
            fontSelector[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            fontSelector[2].trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            fontSelector[1].leadingAnchor.constraint(equalTo: fontSelector[0].trailingAnchor, constant: 6)
        ])
        
        fontSelector.forEach { (selector) in
            NSLayoutConstraint.activate([
                selector.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
                selector.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.3)
            ])
        }
    }
    
    /**
     This method sets the contraints for the color selector buttons.
     */
    private func setColorSelectorConstraints() {
        NSLayoutConstraint.activate([
            colorSelector[0].topAnchor.constraint(greaterThanOrEqualTo: formatLabel.bottomAnchor, constant: 10),
            colorSelector[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            colorSelector[0].bottomAnchor.constraint(greaterThanOrEqualTo: fontSelector[0].topAnchor, constant: -16),
            colorSelector[0].heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            colorSelector[0].widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15)
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
            formatSelector[0].topAnchor.constraint(greaterThanOrEqualTo: formatLabel.bottomAnchor, constant: 10),
            formatSelector[0].trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            formatSelector[0].bottomAnchor.constraint(greaterThanOrEqualTo: fontSelector[2].topAnchor, constant: -16),
            formatSelector[0].heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            formatSelector[0].widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.12)
        ])
        
        for index in 1..<formatSelector.count {
            NSLayoutConstraint.activate([
                formatSelector[index].topAnchor.constraint(equalTo: formatSelector[0].topAnchor),
                formatSelector[index].trailingAnchor.constraint(equalTo: formatSelector[index - 1].leadingAnchor, constant: -16),
                formatSelector[index].bottomAnchor.constraint(equalTo: formatSelector[0].bottomAnchor),
                formatSelector[index].heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
                formatSelector[index].widthAnchor.constraint(equalTo: formatSelector[0].widthAnchor)
            ])
        }
    }
    
    /**
     This method sets the shadow for the background view.
     */
    private func setBackgroundShadow() {
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        
        let shadowColor = #colorLiteral(red: 0.05490196078, green: 0.01568627451, blue: 0.07843137255, alpha: 1)
        backgroundView.layer.shadowColor = shadowColor.cgColor
        backgroundView.layer.shadowOpacity = 0.16
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundView.layer.shadowRadius = 12
        backgroundView.layer.masksToBounds = false

        backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
        backgroundView.layer.shouldRasterize = true
        backgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func didMoveToWindow() {
        colorSelector.forEach { (selector) in
            selector.setCornerRadius()
        }
        
        setBackgroundShadow()
        formatSelector.forEach { (button) in
            button.setTintColor()
        }
    }
}
