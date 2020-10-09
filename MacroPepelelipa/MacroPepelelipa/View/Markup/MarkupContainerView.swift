//
//  MarkupContainerView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 24/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

enum FormatSelector {
    case italic
    case bold
    case highlight
}

enum ColorSelector {
    case black
    case green
    case red
}

enum FontSelector: String {
    case merriweather = "Merriweather"
    case openSans = "OpenSans"
    case dancingScript = "Dancing"
}

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
    
    private lazy var colorSelector: [ColorSelector: MarkupToggleButton] = {
        var buttons = [ColorSelector: MarkupToggleButton]()
        var buttonColors: [UIColor] = [UIColor.bodyColor ?? .black, UIColor.notebookColors[4], UIColor.notebookColors[14]]
        
        buttonColors.forEach { (color) in
            var newButton = MarkupToggleButton(frame: .zero, color: color)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(delegate, action: #selector(delegate?.changeTextColor), for: .touchDown)
            
            if color == buttonColors[0] {
                buttons[.black] = newButton
            } else if color == buttonColors[1] {
                buttons[.green] = newButton
            } else {
                buttons[.red] = newButton
            }
        }
        
        return buttons
    }()
    
    private lazy var formatSelector: [FormatSelector: MarkupToggleButton] = {
        var buttons = [FormatSelector: MarkupToggleButton]()
        var imageNames: [FormatSelector: String] = [.italic: "italic", .bold: "bold", .highlight: "pencil.tip"]
        
        for (key, imageName) in imageNames {
            var newButton = createButton(
                normalStateImage: UIImage(systemName: imageName),
                titleLabel: nil
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            
            if key == .italic {
                newButton.addTarget(delegate, action: #selector(delegate?.makeTextItalic), for: .touchDown)
            } else if key == .bold {
                newButton.addTarget(delegate, action: #selector(delegate?.makeTextBold), for: .touchDown)
            } else {
                newButton.addTarget(delegate, action: #selector(delegate?.highlightText), for: .touchUpInside)
            }
            
            buttons[key] = newButton
        }
        
        return buttons
    }()
    
    private lazy var fontSelector: [FontSelector: MarkupToggleButton] = {
        var buttons = [FontSelector: MarkupToggleButton]()
        let systemFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        var fonts: [UIFont: FontSelector] = [UIFont.merriweather ?? systemFont: .merriweather, UIFont.openSans ?? systemFont: .openSans, UIFont.dancingScript ?? systemFont: .dancingScript]
        
        for font in fonts {
            var newButton = createButton(
                normalStateImage: nil,
                titleLabel: font.value.rawValue,
                font: font.key
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(delegate, action: #selector(delegate?.changeTextFont), for: .touchDown)
            buttons[font.value] = newButton
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
        
        for (_, selector) in colorSelector {
            backgroundView.addSubview(selector)
        }
        
        for (_, selector) in formatSelector {
            backgroundView.addSubview(selector)
        }
        
        for (_, selector) in fontSelector {
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
    
    /**
     This method creates a MarkupToggleButton with a UIImage or a title.
     
     - Parameters:
        - normalStateImage: The UIImage that will be the button's background.
        - titleLabel: The string containing the button's title.
     
     - Returns: The created MarkupToggleButton.
     */
    private func createButton(normalStateImage: UIImage?, titleLabel: String?, font: UIFont? = nil) -> MarkupToggleButton {
        var button = MarkupToggleButton(normalStateImage: nil, title: nil)
        
        if normalStateImage != nil {
            let markupButton = MarkupToggleButton(normalStateImage: normalStateImage, title: nil)
            button = markupButton
        } else if titleLabel != nil {
            let markupButton = MarkupToggleButton(normalStateImage: nil, title: titleLabel, font: font)
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
        guard let merriweather = fontSelector[.merriweather], let openSans = fontSelector[.openSans], let dancing = fontSelector[.dancingScript] else {
            return
        }
        
        NSLayoutConstraint.activate([
            merriweather.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            dancing.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            openSans.leadingAnchor.constraint(equalTo: merriweather.trailingAnchor, constant: 15)
        ])
        
        for (key, selector) in fontSelector {
            NSLayoutConstraint.activate([
                selector.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
                selector.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: key == .merriweather ? 0.35 : 0.25)
            ])
        }
    }
    
    /**
     This method sets the contraints for the color selector buttons.
     */
    private func setColorSelectorConstraints() {
        guard let black = colorSelector[.black], let green = colorSelector[.green], let merriweather = fontSelector[.merriweather] else {
            return
        }
        
        NSLayoutConstraint.activate([
            black.topAnchor.constraint(greaterThanOrEqualTo: formatLabel.bottomAnchor, constant: 10),
            black.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            black.bottomAnchor.constraint(greaterThanOrEqualTo: merriweather.topAnchor, constant: -16),
            black.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            black.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15)
        ])
        
        for (key, selector) in colorSelector where key != .black {
            var lastSelector = black
            if key == .red {
                lastSelector = green
            }
            
            NSLayoutConstraint.activate([
                selector.topAnchor.constraint(equalTo: black.topAnchor),
                selector.leadingAnchor.constraint(equalTo: lastSelector.trailingAnchor, constant: 10),
                selector.bottomAnchor.constraint(equalTo: black.bottomAnchor),
                selector.heightAnchor.constraint(equalTo: black.heightAnchor),
                selector.widthAnchor.constraint(equalTo: black.widthAnchor)
            ])
        }
    }
    
    /**
     This method sets the contraints for the format selector buttons.
     */
    private func setFormatSelectorConstraints() {
        guard let italic = formatSelector[.italic], let bold = formatSelector[.bold], let dancingScript = fontSelector[.dancingScript] else {
            return
        }
        
        NSLayoutConstraint.activate([
            italic.topAnchor.constraint(greaterThanOrEqualTo: formatLabel.bottomAnchor, constant: 10),
            italic.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            italic.bottomAnchor.constraint(greaterThanOrEqualTo: dancingScript.topAnchor, constant: -16),
            italic.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
            italic.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.12)
        ])
        
        for (key, selector) in formatSelector where key != .italic {
            var lastSelector = italic
            if key == .highlight {
                lastSelector = bold
            }
            
            NSLayoutConstraint.activate([
                selector.topAnchor.constraint(equalTo: italic.topAnchor),
                selector.trailingAnchor.constraint(equalTo: lastSelector.leadingAnchor, constant: -16),
                selector.bottomAnchor.constraint(equalTo: italic.bottomAnchor),
                selector.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.15),
                selector.widthAnchor.constraint(equalTo: italic.widthAnchor)
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
        for (_, selector) in colorSelector {
            selector.setCornerRadius()
        }
        setBackgroundShadow()
        updateSelectors()
    }
    
    /**
     This public methos updates the selectors appearence based on the text style.
     */
    public func updateSelectors() {
        guard let textView = self.textView else {
            return
        }
        
        formatSelector[.italic]?.isSelected = textView.checkTrait(.traitItalic)
        formatSelector[.bold]?.isSelected = textView.checkTrait(.traitBold)
        formatSelector[.highlight]?.isSelected = textView.checkBackground()

        for (_, button) in formatSelector {
            button.setTintColor()
        }
        
        let textcolor = textView.getTextColor()
        for (_, button) in colorSelector {
            button.isSelected = (textcolor == button.backgroundColor)
        }
        
        let textFont = textView.getTextFont()
        for (_, button) in fontSelector {
            button.isSelected = (textFont.familyName == button.titleLabel?.font.familyName)
        }
    }
    
    /**
     This methos updates the color selectors by comparing each one with the sender button.
     
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    public func updateColorSelectors(sender: MarkupToggleButton) {
        for (_, button) in colorSelector where button != sender {
            button.isSelected = false
        }
    }
    
    /**
     This methos updates the font selectors by comparing each one with the sender button.
     
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    public func updateFontSelectors(sender: MarkupToggleButton) {
        for (_, button) in fontSelector where button != sender {
            button.isSelected = false
            button.setTintColor()
        }
    }
}
