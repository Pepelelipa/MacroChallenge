//
//  ListStyle.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public enum ListStyle {
    case bullet
    case numeric

    public static let paragraphStyle: NSParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 8

        return paragraphStyle
    }()

    internal var indicator: String {
        switch self {
        case .bullet:
            return "\u{2022}"
        case .numeric:
            return "."
        }
    }
    private var foregroundColor: UIColor {
        switch self {
        case .bullet:
            return .bodyColor ?? .black
        case .numeric:
            return .bodyColor ?? .black
        }
    }
    private var backgroundColor: UIColor {
        switch self {
        case .bullet:
            return .clear
        case .numeric:
            return .clear
        }
    }

    public func getAttributedString(occurrence: Int) -> NSAttributedString {
        let attributedString: NSAttributedString

        let font = Fonts.defaultTextFont.bold() ?? Fonts.defaultTextFont
        let kern = 6

        if self == .numeric {
            let mutableString = NSMutableAttributedString(string: "\(occurrence)\(indicator)", attributes: [
                .font: font,
                .foregroundColor: foregroundColor,
                .backgroundColor: backgroundColor,
                .paragraphStyle: ListStyle.paragraphStyle,
                .kern: kern
            ])
            mutableString.addAttribute(.kern, value: 0, range: NSRange(location: 0, length: "\(occurrence)".count))

            attributedString = mutableString
        } else {
            attributedString = NSAttributedString(
                string: indicator,
                attributes: [
                    .font: font,
                    .foregroundColor: foregroundColor,
                    .backgroundColor: backgroundColor,
                    .paragraphStyle: ListStyle.paragraphStyle,
                    .kern: kern
                ])
        }
        return attributedString
    }
}
