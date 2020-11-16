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
        if let first = Fonts.availableFonts.first(where: { $0.familyName == familyName }) {
            return first
        }
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    func toFirstHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            return self.withSize(32).bold() ?? .boldSystemFont(ofSize: 32)
        } else {
            return self.withSize(26).bold() ?? .boldSystemFont(ofSize: 26)
        }
    }

    func toSecondHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            return self.withSize(26).bold() ?? .boldSystemFont(ofSize: 26)
        } else {
            return self.withSize(20).bold() ?? .boldSystemFont(ofSize: 20)
        }
    }

    func toThirdHeaderFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            return self.withSize(22).bold() ?? .boldSystemFont(ofSize: 22)
        } else {
            return self.withSize(18).bold() ?? .boldSystemFont(ofSize: 18)
        }
    }
    
    func bold() -> UIFont? {
        return withTraits(.traitBold)
    }
    
    func italic() -> UIFont? {
        return withTraits(.traitItalic)
    }

    func light() -> UIFont? {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .thin)
    }
    
    // MARK: - Trait Functions

    /**
     This method adds traits to a UIFont.
     - Parameter traits: The Symbolic Traits to describe the font.
     - Returns: An optional UIFont with the described traits.
     */
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont? {
        var newTraits = fontDescriptor.symbolicTraits
        for trait in traits {
            if !newTraits.contains(trait) {
                newTraits.insert(trait)
            }
        }

        guard let descriptor = fontDescriptor.withSymbolicTraits(newTraits) else {
            return nil
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    ///Checks if a font has some trait
    func hasTrait(_ trait: UIFontDescriptor.SymbolicTraits) -> Bool {
        return self.fontDescriptor.symbolicTraits.contains(trait)
    }

    /**
     This method removes a trait from a UIFont.
     - Parameters:
     - font: The UIFont that will be checked to remove the trait.
     - trait: A symbolic trait describing the trait to be removed.

     - Returns: A UIFont without the chosen trait.
     */
    func removeTrait(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        var traits = self.fontDescriptor.symbolicTraits

        if traits.contains(trait) {
            traits.remove(trait)
        }

        if let descriptor = self.fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0)
        }

        return self
    }
}
