//
//  StringExtension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal extension String {
    func toStyle(font: UIFont = .defaultFont, _ style: FontStyle) -> NSAttributedString {
        toFontWithDefaultColor(font: font.toStyle(style))
    }

    func toPlaceholder() -> NSAttributedString {
        let mutable = toFontWithDefaultColor(font: UIFont.defaultFont)
        return mutable.withForegroundColor(.placeholderColor ?? .placeholderText)
    }

    private func toFontWithDefaultColor(font: Any) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: self.count)
        let mutableString = NSMutableAttributedString(string: self)

        mutableString.addAttribute(.font, value: font, range: range)
        mutableString.addAttribute(.foregroundColor, value: UIColor.bodyColor ?? .black, range: range)

        return mutableString
    }
}
