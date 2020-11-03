//
//  HeaderFont.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public enum FontStyle: Int {
    case h1 = 1
    case h2 = 2
    case h3 = 3
    case paragraph = 4
}

internal extension UIFont {

    // MARK: Fonts
    static let openSans: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "OpenSans", size: 16)
        case .pad:
            return UIFont(name: "OpenSans", size: 21)
        default:
            return UIFont(name: "OpenSans", size: UIFont.labelFontSize + 1)
        }
    }()

    static let merriweather: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "Merriweather", size: 15)
        case .pad:
            return UIFont(name: "Merriweather", size: 20)
        default:
            return UIFont(name: "Merriweather", size: UIFont.labelFontSize)
        }
    }()

    static let dancingScript: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "Dancing Script", size: 18)
        case .pad:
            return UIFont(name: "Dancing Script", size: 23)
        default:
            return UIFont(name: "Dancing Script", size: UIFont.labelFontSize + 3)
        }
    }()

    static var defaultFont: UIFont {
        if let merriweather = merriweather {
            return merriweather
        } else {
            return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
    }
    static var defaultHeader: UIFont {
        if let openSans = openSans {
            return openSans
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            return systemFont(ofSize: 16)
        } else {
            return systemFont(ofSize: 21)
        }
    }

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
        if let font = UIFont.openSans,
           familyName == font.familyName {
            return font
        } else if let font = UIFont.merriweather,
                  familyName == font.familyName {
            return font
        } else if let font = UIFont.dancingScript,
                  familyName == font.familyName {
            return font
        } else {
            return UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
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
