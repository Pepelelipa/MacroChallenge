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
        let mutableString = NSMutableAttributedString(string: self)
        if let font = UIFont.merriweather {
        mutableString.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.count))
        }
        mutableString.addAttribute(.foregroundColor, value: MarkdownParser.defaultColor, range: NSRange(location: 0, length: self.count))

        return mutableString
    }
}
