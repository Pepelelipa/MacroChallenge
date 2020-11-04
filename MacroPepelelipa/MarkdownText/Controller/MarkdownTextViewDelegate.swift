//
//  MarkdownTextViewDelegate.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

open class MarkdownTextViewDelegate: NSObject, UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderColor {
            textView.attributedText = "".toStyle(.paragraph)
            textView.textColor = .bodyColor
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if let textView = textView as? MarkdownTextView,
           textView.text == "" {
            textView.textColor = .placeholderColor ?? .placeholderText
            textView.attributedText = textView.placeholder?.toPlaceholder()
        }
    }

    var ignore: Bool = false
    open func textViewDidChangeSelection(_ textView: UITextView) {
        //always checks the one on the right
        guard !ignore,
              textView.attributedText != nil,
              textView.textColor != .placeholderColor else {
            return
        }
        var newRange = NSRange(location: textView.selectedRange.location, length: 1)
        if textView.selectedRange.location + 1 > textView.attributedText.length {
            newRange.location -= 1
            if newRange.location < 0 || newRange.location + 1 > textView.attributedText.length {
                return
            }
        }

        guard let textView = textView as? MarkdownTextView else {
            return
        }
        textView.attributedText.enumerateAttributes(in: newRange, options: .longestEffectiveRangeNotRequired) { (attributes, _, _) in
            if attributes[.paragraphStyle] as? NSParagraphStyle === ListStyle.paragraphStyle,
               attributes[.kern] != nil {
                ignore = true
                textView.selectedRange.location += 1
                ignore = false
                return
            }
            if let font = attributes[.font] as? UIFont {
                textView.activeFont = font
            }
            if let highlightColor = attributes[.backgroundColor] as? UIColor {
                if highlightColor == UIColor.highlightColor {
                    textView.isHighlighted = true
                } else {
                    textView.isHighlighted = false
                }
            }
            if attributes[.underlineStyle] != nil {
                textView.isUnderlined = true
            } else {
                textView.isUnderlined = false
            }
            if let color = attributes[.foregroundColor] as? UIColor {
                textView.color = color
            }
        }
    }
}
