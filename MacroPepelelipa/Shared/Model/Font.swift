//
//  HeaderFont.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {
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
    
    static let firstHeaderFont: UIFont = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont.openSans?.withSize(26).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 26)
        case .pad:
            return UIFont.openSans?.withSize(32).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 32)
        default:
            return UIFont.boldSystemFont(ofSize: 26)
        }
    }()

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
}
