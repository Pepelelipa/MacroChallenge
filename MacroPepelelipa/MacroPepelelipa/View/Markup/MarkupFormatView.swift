//
//  MarkupFormatView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 09/10/20.
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

internal class MarkupFormatView: UIView {

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
    
    required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
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
    
    override func didMoveToWindow() {
        for (_, selector) in colorSelector {
            selector.setCornerRadius()
        }
        updateSelectors()
    }
    
    /**
     This public methos updates the selectors appearence based on the text style.
     */
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
     This methos updates the color selectors by comparing each one with the sender button.
     
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateColorSelectors(sender: MarkupToggleButton) {
        for (_, button) in colorSelector where button != sender {
            button.isSelected = false
        }
    }
    
    /**
     This methos updates the font selectors by comparing each one with the sender button.
     
     - Parameter sender: The MarkupToggleButton that was last selected.
     */
    internal func updateFontSelectors(sender: MarkupToggleButton) {
        for (_, button) in fontSelector where button != sender {
            button.isSelected = false
            button.setTintColor()
        }
    }

}
