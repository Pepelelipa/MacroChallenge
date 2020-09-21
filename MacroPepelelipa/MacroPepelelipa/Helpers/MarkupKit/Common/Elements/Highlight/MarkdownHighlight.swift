//
//  MarkdownHighlight.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

open class MarkdownHighlight: MarkdownCommonElement {
    fileprivate static let regex = "(.?|^)(\\:\\:|__)(?=\\S)(.+?)(?<=\\S)(\\2)"

    open var font: MarkdownFont?
    open var color: MarkdownColor?

    open var regex: String {
        return MarkdownHighlight.regex
    }

    public init(font: MarkdownFont? = nil, color: MarkdownColor? = nil) {
        self.font = font?.bold()
        self.color = color
    }
}
