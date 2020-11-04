//
//  TraitFont Extension.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension UIFont {
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

    func bold() -> UIFont? {
        return withTraits(.traitBold)
    }

    func italic() -> UIFont? {
        return withTraits(.traitItalic)
    }

    func light() -> UIFont? {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .thin)
    }
}
