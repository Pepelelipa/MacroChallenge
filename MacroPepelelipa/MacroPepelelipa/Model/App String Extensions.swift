//
//  App String Extensions.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 04/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import MarkdownText

internal extension String {
    func toStyle(font: UIFont = Fonts.defaultTextFont, _ style: FontStyle) -> NSAttributedString {
        toFontWithDefaultColor(font: font.toStyle(style))
    }

    func toPlaceholder() -> NSAttributedString {
        let mutable = toFontWithDefaultColor(font: Fonts.defaultTextFont)
        return mutable.withForegroundColor(.placeholderColor ?? .placeholderText)
    }

    func toFontWithDefaultColor(font: Any) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: self.count)
        let mutableString = NSMutableAttributedString(string: self)

        mutableString.addAttribute(.font, value: font, range: range)
        mutableString.addAttribute(.foregroundColor, value: UIColor.bodyColor ?? .black, range: range)

        return mutableString
    }
}
