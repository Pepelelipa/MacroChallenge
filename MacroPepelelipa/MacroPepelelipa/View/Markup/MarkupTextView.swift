//
//  MarkupTextView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian, 
//             Leonardo Amorim de Oliveira and 
//             Pedro Henrique Guedes Silveira on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextView: UITextView {
    
    // MARK: - Variables and Constants
    
    private var snap: UISnapBehavior?
    private var imageView: UIImageView?
    internal var animator: UIDynamicAnimator?
    
    // MARK: - Initializers

    internal init(frame: CGRect, delegate: MarkupTextViewDelegate? = nil) {
        super.init(frame: frame, textContainer: nil)
        
        self.delegate = delegate
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .backgroundColor
        self.textColor = .placeholderColor
        self.tintColor = .actionColor
        self.font = MarkdownParser.defaultFont
        
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
              let delegate = coder.decodeObject(forKey: "delegate") as? MarkupTextViewDelegate else {
            return nil
        }

        self.init(frame: frame, delegate: delegate)
    }
    
    // MARK: - Override functions
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if let snap = snap {
                animator?.removeBehavior(snap)
            }

            guard let image = imageView else {
                return
            }
            snap = UISnapBehavior(item: image, snapTo: location)

            if let snap = snap {
                animator?.addBehavior(snap)
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let snap = snap {
                animator?.removeBehavior(snap)
                self.snap = nil
            }
            if let frame = imageView?.frame {
                let exclusionPath = UIBezierPath(rect: frame)
                self.textContainer.exclusionPaths = [exclusionPath]
            }
            imageView = nil
        }
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: - Touch functions
    
    /**
     This method checks if it finds a UIImageView on the same location were the user touched the screen. If a UIImageView was found, the image is returned. If not, returns nil.
     - Parameter touch: The UITouch which location will be checked.
     - Returns: A UIImageView if an image was found on the touch location or nil if nothing was found.
     */
    private func checkTouch(_ touch: UITouch) -> UIImageView? {
        for subview in subviews {
            if let image = subview as? UIImageView {
                if image.frame.contains(touch.location(in: self)) {
                    return subview as? UIImageView
                }
            }
        }
        return nil
    }
    
    // MARK: - Lists and Topics functions
    
    /**
     This method calls the delegate method to clear special characters on the text.
     - Returns: A boolean indicating if the characters where cleared or not.
     */
    internal func clearIndicatorCharacters() -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        return delegate.clearIndicatorCharacters(self)
    }
    
    /**
     Calls the delegate method to add a list on the text.
     - Parameters:
        - type: The type of list to be added (bullet, numeric or quote)
        - lineCleared: A boolean indicating if the line was cleared or not.
     */
    internal func addList(of type: ListStyle, _ lineCleared: Bool) {
        (self.delegate as? MarkupTextViewDelegate)?.addList(on: self, type: type, lineCleared)
    }
    
    /**
     Calls the delegate method to add a header to the text.
     - Parameter style: The header style to be added.
     */
    internal func addHeader(with style: HeaderStyle) {
        (self.delegate as? MarkupTextViewDelegate)?.addHeader(on: self, with: style)
    }
    
    // MARK: - Font functions
    
    ///This method calls the delegate's method to add italic attributes.
    internal func addItalic() {
        (self.delegate as? MarkupTextViewDelegate)?.addItalic(on: self)
    }
    
    ///This method calls the delegate's method to add bold attributes.
    internal func addBold() {
        (self.delegate as? MarkupTextViewDelegate)?.addBold(on: self)
    }
    
    ///This method calls the delegate's method to remove format attributes.
    internal func removeFontTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        (self.delegate as? MarkupTextViewDelegate)?.removeFontTrait(trait: trait)
    }
    
    /**
     This method calls the delegate's method to set the font with a trait.
     - Parameter trait: The trait to be added to the font.
     */
    internal func setFontAttributes(with trait: UIFontDescriptor.SymbolicTraits) {
        (self.delegate as? MarkupTextViewDelegate)?.setFontAttributes(with: trait)
    }
    
    /**
     This method calls the delegate's method to check if the font already has a trait in the selected range.
     - Parameter trait: The trait to be checked.
     */
    internal func checkTrait(_ trait: UIFontDescriptor.SymbolicTraits) -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        return delegate.checkTrait(trait, on: self)
    }
    
    /**
     This method calls the delegate's method to change the text font.
     - Parameter font: The new UIFont for the text.
     - Returns: True if the text font was changed, false if not.
     */
    internal func setTextFont(_ font: UIFont) -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        
        if selectedRange.length == 0 {
            delegate.setFont(font, textView: self)
        } else {
            delegate.setFont(font, range: selectedRange, textView: self)
        }
        return true
    }
    
    /**
     Calls the delegate method to get the current UIFont.
     - Returns: The UIFont on the selected text on the UITextView.
     */
    internal func getTextFont() -> UIFont {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return MarkdownParser.defaultFont
        }
        return delegate.getTextFont(on: self)
    }
    
    // MARK: - Color functions
    
    ///This method calls the delegate's method to set the background color to highlight.
    internal func setTextToHighlight() {
        (self.delegate as? MarkupTextViewDelegate)?.setTextToHighlight()
    }
    
    ///This method calls the delegate's method to set the background color to normal.
    internal func setTextToNormal() {
        (self.delegate as? MarkupTextViewDelegate)?.setTextToNormal()
    }
    
    ///This method calls the delegate's method to add background color attribute.
    internal func setBackgroundColor() {
        (self.delegate as? MarkupTextViewDelegate)?.setBackgroundColor(on: self)
    }
    
    /**
     This method calls the delegate's method to change the text color.
     - Parameter color: The new UIColor for the text.
     - Returns: True if the text color was changed, false if not.
     */
    internal func setTextColor(_ color: UIColor) -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        
        if selectedRange.length == 0 {
            delegate.setTextColor(color, textView: self)
        } else {
            delegate.setTextColor(color, range: selectedRange, textView: self)
        }
        return true
    }
    
    ///This method calls the delegate's method to check the text color and return it.
    internal func getTextColor() -> UIColor {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return MarkdownParser.defaultColor
        }
        return delegate.getTextColor(on: self)
    }
    
    ///This method calls the delegate's method to check if the background attribute has the value of highlighted.
    internal func checkBackground() -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        return delegate.checkBackground(on: self)
    }

    ///Deletes the range or the last character
    override func deleteBackward() {
        let mutableString = NSMutableAttributedString(attributedString: attributedText)

        let range = selectedRange.length == 0 ?
        NSRange(location: mutableString.length - 1, length: 1) :
        selectedRange

        mutableString.deleteCharacters(in: range)
        attributedText = mutableString
    }
}
