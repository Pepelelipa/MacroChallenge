//
//  UIFont+Traits.swift
//  Pods
//
//  Created by Ivan Bruel on 19/07/16.
//
//
import UIKit

extension UIFont {
        
    static let merriweather: UIFont? = {
        return UIFont(name: "Merriweather", size: UIFont.labelFontSize)
    }()
    
    static let openSans: UIFont? = {
        return UIFont(name: "OpenSans", size: UIFont.labelFontSize + 1)
    }()
    
    static let dancingScript: UIFont? = {
        return UIFont(name: "Dancing Script", size: UIFont.labelFontSize + 3)
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
