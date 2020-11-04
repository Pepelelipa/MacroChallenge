//
//  MarkupFormatView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 09/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal enum FormatSelector {
    case italic
    case bold
    case highlight
}

internal enum ColorSelector {
    case black
    case green
    case red
}

internal enum FontSelector: String {
    case merriweather = "Merriweather"
    case openSans = "OpenSans"
    case dancingScript = "Dancing"
}

internal class MarkupFormatView: UIView {
    
    // MARK: - Variables and Constants

    internal weak var textView: MarkupTextView?
    internal weak var viewController: NotesViewController?
    internal weak var delegate: MarkupFormatViewDelegate?
    
    internal private(set) lazy var colorSelector: [ColorSelector: MarkupToggleButton] = {
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
    
    internal private(set) lazy var formatSelector: [FormatSelector: MarkupToggleButton] = {
        var buttons = [FormatSelector: MarkupToggleButton]()
        var imageNames: [FormatSelector: String] = [.italic: "italic", .bold: "bold", .highlight: "highlighter"]
        
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
    
    internal private(set) lazy var fontSelector: [FontSelector: MarkupToggleButton] = {
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
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, owner: MarkupTextView, delegate: MarkupFormatViewDelegate?, viewController: NotesViewController) {
        super.init(frame: frame)
        self.textView = owner
        self.delegate = delegate
        self.viewController = viewController
        
        addSelectors()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Override functions
    
    override func didMoveToWindow() {
        for (_, selector) in colorSelector {
            selector.setCornerRadius()
        }
        updateSelectors()
    }
    
    // MARK: - Functions
        
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
    
    ///This method sets the contraints for the font selector buttons.
    private func setFontSelectorConstraints() {
        guard let merriweather = fontSelector[.merriweather], let openSans = fontSelector[.openSans], let dancing = fontSelector[.dancingScript] else {
            return
        }
        
        NSLayoutConstraint.activate([
            merriweather.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dancing.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            openSans.leadingAnchor.constraint(equalTo: merriweather.trailingAnchor, constant: 6)
        ])
        
        for (key, selector) in fontSelector {
            NSLayoutConstraint.activate([
                selector.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                selector.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: key == .merriweather ? 0.35 : 0.25)
            ])
        }
    }
    
    ///This method sets the contraints for the color selector buttons.
    private func setColorSelectorConstraints() {
        guard let black = colorSelector[.black], let green = colorSelector[.green], let merriweather = fontSelector[.merriweather] else {
            return
        }
        
        NSLayoutConstraint.activate([
            black.topAnchor.constraint(equalTo: self.topAnchor, constant: 36),
            black.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            black.bottomAnchor.constraint(greaterThanOrEqualTo: merriweather.bottomAnchor, constant: -20),
            black.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            black.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
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
    
    ///This method sets the contraints for the format selector buttons.
    private func setFormatSelectorConstraints() {
        guard let italic = formatSelector[.italic], let bold = formatSelector[.bold], let dancingScript = fontSelector[.dancingScript] else {
            return
        }
        
        NSLayoutConstraint.activate([
            italic.topAnchor.constraint(equalTo: self.topAnchor, constant: 36),
            italic.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            italic.bottomAnchor.constraint(greaterThanOrEqualTo: dancingScript.topAnchor, constant: -16),
            italic.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            italic.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.17)
        ])
        
        for (key, selector) in formatSelector where key != .italic {
            var lastSelector = italic
            if key == .highlight {
                lastSelector = bold
                NSLayoutConstraint.activate([
                    selector.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
                ])
            } else {
                NSLayoutConstraint.activate([
                    selector.widthAnchor.constraint(equalTo: italic.widthAnchor)
                ])
            }
            
            NSLayoutConstraint.activate([
                selector.topAnchor.constraint(equalTo: italic.topAnchor),
                selector.trailingAnchor.constraint(equalTo: lastSelector.leadingAnchor, constant: -16),
                selector.bottomAnchor.constraint(equalTo: italic.bottomAnchor),
                selector.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
            ])
        }
    }
    
    ///This method adds subviews to the view.
    internal func addSelectors() {
        for (_, selector) in colorSelector {
            addSubview(selector)
        }
        
        for (_, selector) in formatSelector {
            addSubview(selector)
        }
        
        for (_, selector) in fontSelector {
            addSubview(selector)
        }
    }
    
    ///This method creates the constraints for the iPad as the default device.
    internal func createConstraints() {
        if let superview = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
        
        setFontSelectorConstraints()
        setColorSelectorConstraints()
        setFormatSelectorConstraints()
    }
    
    ///This method updates the selectors appearence based on the text style.
    internal func updateSelectors() {
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
     This method updates the color selectors by comparing each one with the sender button.
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateColorSelectors(sender: MarkupToggleButton) {
        for (_, button) in colorSelector where button != sender {
            button.isSelected = false
        }
    }
    
    /**
     This method updates the font selectors by comparing each one with the sender button.
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateFontSelectors(sender: MarkupToggleButton) {
        for (_, button) in fontSelector where button != sender {
            button.isSelected = false
            button.setTintColor()
        }
    }
    
    ///This method sets the corner radius for the color selectors.
    internal func setCornerRadius() {
        for (_, selector) in colorSelector {
            selector.setCornerRadius()
        }
    }

}
