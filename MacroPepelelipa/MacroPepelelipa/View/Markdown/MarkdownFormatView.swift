//
//  MarkupFormatView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 09/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

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

internal class MarkdownFormatView: UIView, MarkdownObserver {
    
    // MARK: - Variables and Constants

    internal weak var textView: MarkdownTextView?
    internal weak var viewController: NotesViewController?
    
    internal private(set) lazy var colorSelector: [ColorSelector: MarkdownToggleButton] = {
        var buttons = [ColorSelector: MarkdownToggleButton]()
        var buttonColors: [UIColor] = [UIColor.bodyColor ?? .black, UIColor.notebookColors[4], UIColor.notebookColors[14]]
        
        buttonColors.forEach { (color) in
            var newButton = MarkdownToggleButton(frame: .zero, color: color)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(self, action: #selector(setColor(_:)), for: .touchUpInside)
            
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
    
    internal private(set) lazy var formatSelector: [FormatSelector: MarkdownToggleButton] = {
        var buttons = [FormatSelector: MarkdownToggleButton]()
        var imageNames: [FormatSelector: String] = [.italic: "italic", .bold: "bold", .highlight: "pencil.tip"]
        
        for (key, imageName) in imageNames {
            var newButton = createButton(
                normalStateImage: UIImage(systemName: imageName),
                titleLabel: nil
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            
            if key == .italic {
                newButton.addTarget(self, action: #selector(makeTextItalic(_:)), for: .touchUpInside)
            } else if key == .bold {
                newButton.addTarget(self, action: #selector(makeTextBold(_:)), for: .touchUpInside)
            } else {
                newButton.addTarget(self, action: #selector(highlightText(_:)), for: .touchUpInside)
            }
            
            buttons[key] = newButton
        }
        
        return buttons
    }()
    
    internal private(set) lazy var fontSelector: [FontSelector: MarkdownToggleButton] = {
        var buttons = [FontSelector: MarkdownToggleButton]()
        let systemFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        var fonts: [UIFont: FontSelector] = [UIFont.merriweather ?? systemFont: .merriweather, UIFont.openSans ?? systemFont: .openSans, UIFont.dancingScript ?? systemFont: .dancingScript]
        
        for font in fonts {
            var newButton = createButton(
                normalStateImage: nil,
                titleLabel: font.value.rawValue,
                font: font.key
            )
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(self, action: #selector(changeFont(_:)), for: .touchUpInside)
            buttons[font.value] = newButton
        }
        
        return buttons
    }()
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, owner: MarkdownTextView, viewController: NotesViewController) {
        super.init(frame: frame)
        self.textView = owner
        if let delegate = textView?.markdownDelegate as? AppMarkdownTextViewDelegate {
            delegate.addMarkdownObserver(self)
        }
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

    override func removeFromSuperview() {
        if let delegate = textView?.markdownDelegate as? AppMarkdownTextViewDelegate {
            delegate.removeMarkdownObserver(self)
        }
        super.removeFromSuperview()
    }
    
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
    private func createButton(normalStateImage: UIImage?, titleLabel: String?, font: UIFont? = nil) -> MarkdownToggleButton {
        var button = MarkdownToggleButton(normalStateImage: nil, title: nil)
        
        if normalStateImage != nil {
            let markupButton = MarkdownToggleButton(normalStateImage: normalStateImage, title: nil)
            button = markupButton
        } else if titleLabel != nil {
            let markupButton = MarkdownToggleButton(normalStateImage: nil, title: titleLabel, font: font)
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
            }
            
            NSLayoutConstraint.activate([
                selector.topAnchor.constraint(equalTo: italic.topAnchor),
                selector.trailingAnchor.constraint(equalTo: lastSelector.leadingAnchor, constant: -16),
                selector.bottomAnchor.constraint(equalTo: italic.bottomAnchor),
                selector.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
                selector.widthAnchor.constraint(equalTo: italic.widthAnchor)
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

    func didChangeSelection(_ textView: UITextView) {
        updateSelectors()
    }

    ///This method updates the selectors appearence based on the text style.
    internal func updateSelectors() {
        guard let textView = self.textView else {
            return
        }
        
        formatSelector[.italic]?.isSelected = textView.isItalic
        formatSelector[.bold]?.isSelected = textView.isBold
        formatSelector[.highlight]?.isSelected = textView.isHighlighted

        for (_, button) in formatSelector {
            button.setTintColor()
        }
        
        let textcolor = textView.color
        for (_, button) in colorSelector {
            button.isSelected = (textcolor == button.backgroundColor)
        }

        let textFont = textView.activeFont
        for (_, button) in fontSelector {
            button.isSelected = (textFont.familyName == button.titleLabel?.font.familyName)
        }
    }

    @objc func setColor(_ sender: UIButton) {
        textView?.setColor(sender.backgroundColor ?? .black)
        updateSelectors()
    }

    @objc func makeTextBold(_ sender: UIButton) {
        guard let textView = textView else {
            return
        }
        textView.setBold(!textView.isBold)
        updateSelectors()
    }

    @objc func makeTextItalic(_ sender: UIButton) {
        guard let textView = textView else {
            return
        }
        textView.setItalic(!textView.isItalic)
        updateSelectors()
    }

    @objc func highlightText(_ sender: UIButton) {
        guard let textView = textView else {
            return
        }
        textView.setHighlighted(!textView.isHighlighted)
        updateSelectors()
    }

    @objc func changeFont(_ sender: UIButton) {
        if let match = fontSelector.first(where: { $0.value == sender }) {
            let newFont: UIFont
            switch match.key {
            case .dancingScript:
                newFont = UIFont.dancingScript ?? UIFont()
            case .merriweather:
                newFont = UIFont.merriweather ?? UIFont()
            case .openSans:
                newFont = UIFont.openSans ?? UIFont()
            }
            textView?.setFont(to: newFont)
        }
    }
    
    /**
     This method updates the color selectors by comparing each one with the sender button.
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateColorSelectors(sender: MarkdownToggleButton) {
        for (_, button) in colorSelector where button != sender {
            button.isSelected = false
        }
    }
    
    /**
     This method updates the font selectors by comparing each one with the sender button.
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateFontSelectors(sender: MarkdownToggleButton) {
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
