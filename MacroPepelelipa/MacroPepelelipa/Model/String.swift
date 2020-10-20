//
//  String.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 20/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal extension String {
    func toNoteDefaulText() -> NSAttributedString {
        if let font = UIFont.merriweather {
            return toFontWithDefaultColor(font: font)
        } else {
            return NSAttributedString(string: self)
        }
    }
    func toNoteH2Text() -> NSAttributedString {
        return toFontWithDefaultColor(font: MarkdownHeader.secondHeaderFont)
    }
    func toNoteH3Text() -> NSAttributedString {
        return toFontWithDefaultColor(font: MarkdownHeader.thirdHeaderFont)
    }

    private func toFontWithDefaultColor(font: Any) -> NSAttributedString {
        let range = NSRange(location: 0, length: self.count)
        let mutableString = NSMutableAttributedString(string: self)

        mutableString.addAttribute(.font, value: font, range: range)
        mutableString.addAttribute(.foregroundColor, value: MarkdownParser.defaultColor, range: range)

        return mutableString
    }
}
