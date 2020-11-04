//
//  Colors.swift
//  MacroPepelelipa
//
//  Created by Ivan Bruel on 19/07/16.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
import UIKit

extension UIFont {
    
    // MARK: - Variables and Constants
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
    
    // MARK: - Functions
    
    /**
     This method removes a trait from a UIFont.
     - Parameters:
        - font: The UIFont that will be checked to remove the trait.
        - trait: A symbolic trait describing the trait to be removed.
     
     - Returns: A UIFont without the chosen trait.
     */
    public func removeTrait(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        var traits = self.fontDescriptor.symbolicTraits
        
        if traits.contains(trait) {
            traits.remove(trait)
        }
        
        if let descriptor = self.fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0)
        }
        
        return self
    }
    
    func isHeaderFont() -> Bool {
        return self == MarkdownHeader.defaultFont || self == MarkdownHeader.firstHeaderFont || self == MarkdownHeader.secondHeaderFont || self == MarkdownHeader.thirdHeaderFont
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
