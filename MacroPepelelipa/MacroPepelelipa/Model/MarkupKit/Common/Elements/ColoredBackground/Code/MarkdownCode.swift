//
//  MarkdownCode.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation

open class MarkdownCode: MarkdownColoredBackground {
    
    fileprivate static let regex = "(.?|^)(\\`{1,3})(.+?)(\\2)"
    
    open override var regex: String {
        return MarkdownCode.regex
    }
    
    public init(font: MarkdownFont? = MarkdownCode.defaultFont,
                color: MarkdownColor? = nil,
                textHighlightColor: MarkdownColor? = MarkdownCode.defaultHighlightColor,
                textBackgroundColor: MarkdownColor? = MarkdownCode.defaultBackgroundColor) {
        super.init()
        
        self.font = font
        self.color = color
        self.textHighlightColor = textHighlightColor
        self.textBackgroundColor = textBackgroundColor
    }
}
