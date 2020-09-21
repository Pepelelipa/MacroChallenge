//
//  MarkdownHighlight.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

open class MarkdownHighlight: MarkdownColoredBackground {
    
    fileprivate static let regex = "(.?|^)(\\:\\:|__)(?=\\S)(.+?)(?<=\\S)(\\2)"

    open override var regex: String {
        return MarkdownHighlight.regex
    }

    public init(font: MarkdownFont? = MarkdownCode.defaultFont,
                color: MarkdownColor? = nil,
                textHighlightColor: MarkdownColor? = MarkdownCode.defaultHighlightColor,
                textBackgroundColor: MarkdownColor? = MarkdownCode.defaultBackgroundColor) {
        super.init()
        
        self.font = font?.bold()
        self.color = color
        self.textHighlightColor = textHighlightColor
        self.textBackgroundColor = textBackgroundColor
    }
}
