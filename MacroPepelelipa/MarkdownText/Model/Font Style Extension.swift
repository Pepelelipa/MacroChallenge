//
//  Font Style Extension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public extension UIFont {
    // MARK: - Font Style Functions
    func toStyle(_ style: FontStyle) -> UIFont {
        switch style {
        case .paragraph:
            return self.toParagraphFont()
        case .h1:
            return self.toFirstHeaderFont()
        case .h2:
            return self.toSecondHeaderFont()
        case .h3:
            return self.toThirdHeaderFont()
        }
    }

    func toParagraphFont() -> UIFont {
        for font in Fonts.availableFonts {
            if familyName == font.familyName {
                return font
            }
        }
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    func toFirstHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.withSize(32).bold() ?? .boldSystemFont(ofSize: 32)
        } else {
            return self.withSize(26).bold() ?? .boldSystemFont(ofSize: 26)
        }
    }

    func toSecondHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.withSize(26).bold() ?? .boldSystemFont(ofSize: 26)
        } else {
            return self.withSize(20).bold() ?? .boldSystemFont(ofSize: 20)
        }
    }

    func toThirdHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.withSize(22).bold() ?? .boldSystemFont(ofSize: 22)
        } else {
            return self.withSize(18).bold() ?? .boldSystemFont(ofSize: 18)
        }
    }
}
