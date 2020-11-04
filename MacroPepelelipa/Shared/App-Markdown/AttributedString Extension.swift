//
//  AttributedString Extension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension NSAttributedString {
    func withForegroundColor(_ color: UIColor, in range: NSRange? = nil) -> NSAttributedString {
        let newRange = range ?? NSRange(location: 0, length: length)
        return self.withExtraAttribute((.foregroundColor, color), in: newRange)
    }

    func withExtraAttribute(_ attribute: (NSAttributedString.Key, Any), in range: NSRange) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.addAttribute(attribute.0, value: attribute.1, range: range)
        return mutableString
    }
}
